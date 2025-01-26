class Shipper {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String description;
  final double rating;
  final int reviewCount;
  final double pricePerKg;
  final List<String> servingCountries;
  final List<String> destinationCountries;
  final List<ShipmentDate> shipmentDates;
  final Address pickupAddress;
  final bool isVerified;

  Shipper({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.pricePerKg,
    required this.servingCountries,
    required this.destinationCountries,
    required this.shipmentDates,
    required this.pickupAddress,
    required this.isVerified,
  });
}

class ShipmentDate {
  final DateTime departureDate;
  final DateTime arrivalDate;
  final String fromLocation;
  final String toLocation;
  final int availableCapacityKg;

  ShipmentDate({
    required this.departureDate,
    required this.arrivalDate,
    required this.fromLocation,
    required this.toLocation,
    required this.availableCapacityKg,
  });
}

class Address {
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final double latitude;
  final double longitude;

  Address({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}
