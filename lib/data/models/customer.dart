class Customer {
  final int id;
  final String email;
  final String username;
  final String name;
  final String phone;
  final Address? address;

  Customer({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.phone,
    this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    final nameData = json['name'] as Map<String, dynamic>? ?? {};
    final addressData = json['address'] as Map<String, dynamic>?;

    return Customer(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      name: '${nameData['firstname'] ?? ''} ${nameData['lastname'] ?? ''}'.trim(),
      phone: json['phone'] as String? ?? '',
      address: addressData != null ? Address.fromJson(addressData) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'phone': phone,
    };
  }
}

class Address {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeoLocation? geolocation;

  Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    this.geolocation,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String? ?? '',
      street: json['street'] as String? ?? '',
      number: json['number'] as int? ?? 0,
      zipcode: json['zipcode'] as String? ?? '',
      geolocation: json['geolocation'] != null
          ? GeoLocation.fromJson(json['geolocation'] as Map<String, dynamic>)
          : null,
    );
  }
}

class GeoLocation {
  final String lat;
  final String long;

  GeoLocation({required this.lat, required this.long});

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      lat: json['lat'] as String? ?? '',
      long: json['long'] as String? ?? '',
    );
  }
}
