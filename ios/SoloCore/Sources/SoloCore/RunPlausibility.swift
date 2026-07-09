// M1 pace-plausibility (SPEC C7): XP only on plausible segments.
// Pure: [LocationSample] in → RunSummary out. CoreLocation feeds this live;
// tests feed synthetic traces (the M1 counter-move tunes thresholds against
// traces recorded during the real M1 human check, via this same config).

import Foundation

public struct LocationSample {
    public let t: Double // seconds, monotonic
    public let latitude: Double
    public let longitude: Double
    public let horizontalAccuracy: Double // meters; <0 = invalid (CoreLocation convention)

    public init(t: Double, latitude: Double, longitude: Double,
                horizontalAccuracy: Double = 5) {
        self.t = t
        self.latitude = latitude
        self.longitude = longitude
        self.horizontalAccuracy = horizontalAccuracy
    }
}

public struct PlausibilityConfig {
    /// Sustained speed above this is not a human run (bike/drive). km/h.
    /// ponytail: single cap, casual rigor per C7; revisit only from recorded traces.
    public var maxHumanSpeedKmh: Double = 20.0
    /// Above this the segment is a GPS teleport artifact, not motion. km/h.
    public var teleportSpeedKmh: Double = 100.0
    /// Samples with worse accuracy than this are dropped. meters.
    public var maxAccuracyM: Double = 50.0

    public init() {}
}

public struct RunSummary: Equatable {
    /// Distance covered in plausible segments only — the XP-earning distance.
    public let plausibleKm: Double
    /// Total distance including implausible segments (shown, never priced).
    public let totalKm: Double
    public let durationS: Double
    public let implausibleSegments: Int

    public var isFullyPlausible: Bool { implausibleSegments == 0 }
}

public enum RunPlausibility {
    /// Haversine distance in km.
    static func distanceKm(_ a: LocationSample, _ b: LocationSample) -> Double {
        let r = 6371.0088
        let dLat = (b.latitude - a.latitude) * .pi / 180
        let dLon = (b.longitude - a.longitude) * .pi / 180
        let la = a.latitude * .pi / 180, lb = b.latitude * .pi / 180
        let h = sin(dLat / 2) * sin(dLat / 2) + cos(la) * cos(lb) * sin(dLon / 2) * sin(dLon / 2)
        return 2 * r * asin(min(1, h.squareRoot()))
    }

    public static func summarize(_ samples: [LocationSample],
                                 config: PlausibilityConfig = PlausibilityConfig()) -> RunSummary {
        let usable = samples.filter {
            $0.horizontalAccuracy >= 0 && $0.horizontalAccuracy <= config.maxAccuracyM
        }
        guard usable.count >= 2 else {
            return RunSummary(plausibleKm: 0, totalKm: 0,
                              durationS: usable.count == 1 ? 0 : 0, implausibleSegments: 0)
        }
        var plausible = 0.0, total = 0.0, rejected = 0
        for (a, b) in zip(usable, usable.dropFirst()) {
            let dt = b.t - a.t
            guard dt > 0 else { continue }
            let km = distanceKm(a, b)
            let kmh = km / (dt / 3600)
            if kmh > config.teleportSpeedKmh {
                continue // GPS jump: not motion at all — excluded from both totals
            }
            total += km
            if kmh <= config.maxHumanSpeedKmh {
                plausible += km
            } else {
                rejected += 1 // bike/drive pace: shown but never priced
            }
        }
        return RunSummary(plausibleKm: plausible, totalKm: total,
                          durationS: usable.last!.t - usable.first!.t,
                          implausibleSegments: rejected)
    }
}
