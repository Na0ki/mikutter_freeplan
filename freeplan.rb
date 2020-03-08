require_relative 'qa'

Plugin.create(:freeplan) do
  @url = Diva::URI('https://mikutter.hachune.net/faq.json')
  @faq_list = []

  filter_skin_get do |fn, fallback_dirs|
    if File.basename(fn, '.*') == 'mikuslime'
      fallback_dirs << File.join(__dir__, 'skin')
    end
    [fn, fallback_dirs]
  end

  filter_extract_receive_message do |slug, statuses|
    if Plugin[:premiamuplan].spec.nil? && rand(10) == 5
      statuses.push(@faq_list.sample)
    end
    [slug, statuses]
  end

  def fetch
    Delayer.new do
      http = Net::HTTP.new(@url.host, @url.port)
      http.use_ssl = @url.scheme == 'https'

      res = http.request(Net::HTTP::Get.new(@url.path))
      case res
      when Net::HTTPSuccess
        @faq_list = JSON.parse(res.body, symbolize_names: true).map{ |d| Plugin::FreePlan::QA.new(d) }
      else
        []
      end
    end
  end

  fetch
end
