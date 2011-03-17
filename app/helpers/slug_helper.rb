module SlugHelper
  def generate_slug_from_name
    if !self.new_record? #Si ce n'est pas
      return "toto"
    end

    if self.name.empty? || self.name.nil?
      return false
    end

    slug_generated = self.name.downcase
    #slug_generated.strip!
    slug_generated = slug_generated.gsub(/[^a-z0-9\s-]/, '') # Remove non-word characters
    slug_generated = slug_generated.gsub(/\s+/, '-')     # Convert whitespaces to dashes
    slug_generated = slug_generated.gsub(/-\z/, '')      # Remove trailing dashes
    slug_generated = slug_generated.gsub(/-+/, '-')      # get rid of double-dashes

    slug_num = slug_number(slug_generated)
    if slug_num == false
      self.slug = slug_generated
    else
      self.slug = slug_generated+"-"+slug_num.to_s
    end

    return self.slug
  end

  def slug_number(slug_to_test)
    slug_like_objects  = Project.select("slug").
                                  where("slug LIKE ?",slug_to_test+"%").
                                  all()
    slug_strings = []
    slug_like_objects.each do |proj|
      slug_strings.push(proj.slug)
    end

    if !slug_strings.include?(slug_to_test)
      return false
    else
      counter = 1
      slug_found= false
      while !slug_found && counter < 999 do
        if !slug_strings.include?(slug_to_test+"-"+counter.to_s)
          slug_found = true
          return counter
        end
        counter += 1
      end
      return counter # au cas ou
    end

  end
end