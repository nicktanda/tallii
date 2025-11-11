module PhoneHelper
  def country_options_for_phone
    # Simple list of countries with their dial codes
    # Format: [Display text, dial code value]
    countries = [
      ["🇺🇸 United States (+1)", "1"],
      ["🇨🇦 Canada (+1)", "1"],
      ["🇬🇧 United Kingdom (+44)", "44"],
      ["🇦🇺 Australia (+61)", "61"],
      ["🇫🇷 France (+33)", "33"],
      ["🇩🇪 Germany (+49)", "49"],
      ["🇪🇸 Spain (+34)", "34"],
      ["🇮🇹 Italy (+39)", "39"],
      ["🇯🇵 Japan (+81)", "81"],
      ["🇨🇳 China (+86)", "86"],
      ["🇮🇳 India (+91)", "91"],
      ["🇲🇽 Mexico (+52)", "52"],
      ["🇧🇷 Brazil (+55)", "55"],
      ["🇿🇦 South Africa (+27)", "27"],
      ["🇰🇷 South Korea (+82)", "82"],
      ["🇳🇱 Netherlands (+31)", "31"],
      ["🇸🇪 Sweden (+46)", "46"],
      ["🇳🇴 Norway (+47)", "47"],
      ["🇫🇮 Finland (+358)", "358"],
      ["🇮🇪 Ireland (+353)", "353"],
      ["🇳🇿 New Zealand (+64)", "64"],
      ["🇸🇬 Singapore (+65)", "65"],
      ["🇦🇪 UAE (+971)", "971"],
      ["🇷🇺 Russia (+7)", "7"],
      ["🇨🇭 Switzerland (+41)", "41"],
      ["🇦🇹 Austria (+43)", "43"],
      ["🇧🇪 Belgium (+32)", "32"],
      ["🇩🇰 Denmark (+45)", "45"],
      ["🇵🇱 Poland (+48)", "48"],
      ["🇵🇹 Portugal (+351)", "351"],
      ["🇬🇷 Greece (+30)", "30"],
      ["🇹🇷 Turkey (+90)", "90"],
      ["🇮🇱 Israel (+972)", "972"],
      ["🇸🇦 Saudi Arabia (+966)", "966"],
      ["🇦🇷 Argentina (+54)", "54"],
      ["🇨🇱 Chile (+56)", "56"],
      ["🇨🇴 Colombia (+57)", "57"],
      ["🇵🇪 Peru (+51)", "51"],
      ["🇻🇪 Venezuela (+58)", "58"],
      ["🇲🇾 Malaysia (+60)", "60"],
      ["🇵🇭 Philippines (+63)", "63"],
      ["🇹🇭 Thailand (+66)", "66"],
      ["🇻🇳 Vietnam (+84)", "84"],
      ["🇮🇩 Indonesia (+62)", "62"],
      ["🇵🇰 Pakistan (+92)", "92"],
      ["🇧🇩 Bangladesh (+880)", "880"],
      ["🇪🇬 Egypt (+20)", "20"],
      ["🇳🇬 Nigeria (+234)", "234"],
      ["🇰🇪 Kenya (+254)", "254"]
    ]
    
    countries
  end
  
  def phone_with_country_code_field(form, field_name, options = {})
    content_tag :div, class: "phone-input-group w-full" do
      # Apply same styling but keep w-24 for country select
      country_classes = options[:class] ? "#{options[:class].gsub(/w-\w+/, '')} w-24" : "border rounded-lg p-2 w-24"

      country_select = select_tag(
        "#{form.object_name}[country_code]",
        options_for_select(country_options_for_phone, selected: '1'),
        class: country_classes
      )

      # Add Stimulus controller and data attributes
      phone_field = form.telephone_field(
        field_name,
        {
          class: options[:class] || "border flex-1 rounded-lg p-2",
          placeholder: options[:placeholder] || "Phone number",
          data: {
            controller: "phone-input",
            phone_input_target: "input",
            action: "input->phone-input#clean"
          }
        }.merge(options.except(:class, :placeholder))
      )

      content_tag(:div, class: "flex gap-3 w-full") do
        country_select + phone_field
      end
    end
  end
end