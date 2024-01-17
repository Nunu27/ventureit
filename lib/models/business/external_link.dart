enum LinkSite {
  website('Website'),
  gmaps('Google Maps', logo: 'assets/images/site_logo/maps.png'),
  whatsapp('WhatsApp', logo: 'assets/images/site_logo/whatsapp.png'),
  linktree('LinkTree', logo: 'assets/images/site_logo/linktree.png'),
  instagram('Instagram', logo: 'assets/images/site_logo/instagram.png'),
  gofood('GoFood', logo: 'assets/images/site_logo/gofood.png'),
  tiktok('TikTok', logo: 'assets/images/site_logo/tiktok.png'),
  twitter('Twitter', logo: 'assets/images/site_logo/x.png');

  const LinkSite(this.source,
      {this.logo = 'assets/images/site_logo/instagram.png'});

  final String source;
  final String logo;
}

final linkHostname = {
  'wa.me': LinkSite.gmaps,
  'linktr.ee': LinkSite.linktree,
  'www.instagram.com': LinkSite.instagram,
  'gofood.co.id': LinkSite.gofood,
  'tiktok.com': LinkSite.tiktok,
  'twitter.com': LinkSite.twitter,
};

class ExternalLink {
  final LinkSite site;
  final String url;

  ExternalLink({
    required this.site,
    required this.url,
  });

  ExternalLink copyWith({
    LinkSite? site,
    String? url,
  }) {
    return ExternalLink(
      site: site ?? this.site,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'site': site.name,
      'url': url,
    };
  }

  factory ExternalLink.fromMap(Map<String, dynamic> map) {
    return ExternalLink(
      site: LinkSite.values.byName(map['site'] as String),
      url: map['url'] as String,
    );
  }
  @override
  String toString() => 'ExternalLink(site: $site, url: $url)';

  @override
  bool operator ==(covariant ExternalLink other) {
    if (identical(this, other)) return true;

    return other.site == site && other.url == url;
  }

  @override
  int get hashCode => site.hashCode ^ url.hashCode;
}
