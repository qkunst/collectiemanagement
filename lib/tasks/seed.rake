namespace :seed do
  desc "generate works"
  task thousand: :environment do
    c = Collection.create(name: "Seed #{Time.now}")
    themes = Theme.all
    subsets = Subset.all
    media = Medium.all
    artists = Artist.all
    styles = Style.all
    1000.times do |time|
      c.works.create(
        title: "Work #{time}",
        themes: themes.sample(2),
        subset: subsets.sample,
        location: "Location #{time}",
        medium: media.sample,
        artists: artists.sample((rand > 0.9) ? 2 : 1),
        style: styles.sample
      )
      print "."
    end
  end

end