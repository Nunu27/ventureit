enum LinkSite {
  website('Website'),
  gmaps('Google Maps'),
  whatsapp('WhatsApp'),
  linktree('LinkTree'),
  instagram('Instagram'),
  gofood('GoFood'),
  tiktok('TikTok'),
  twitter('Twitter');

  const LinkSite(this.source, {this.logo});

  final String source;
  final String? logo;
}

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
