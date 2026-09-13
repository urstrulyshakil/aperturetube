class ArtisanProfile {
  final String id;
  final String name;
  final String specialty;
  final String category;
  final double rating;
  final int reviewsCount;
  final String startingPrice;
  final String availability;
  final String gearKit;
  final String avatarUrl;
  final String coverImageUrl;
  final bool isVerifiedMaster;
  final bool isOnline;

  const ArtisanProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.startingPrice,
    required this.availability,
    required this.gearKit,
    required this.avatarUrl,
    required this.coverImageUrl,
    this.isVerifiedMaster = true,
    this.isOnline = true,
  });
}
