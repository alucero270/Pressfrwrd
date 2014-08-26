class LabeledBootstrapFormBuilder < ActionView::Helpers::FormBuilder
  %w[text_field password_field].each do |method|
    define_method(method) do |name, options={}|
      @template.content_tag :div, class: "form-group #{name.to_s}" do
        klass=((options[:class]||"").split(" ")+["form-control #{name.to_s}"]).join(" ")
        label_name_args=[options.delete(:label)]||[]
        label(name,*label_name_args,class:"control-label")+super(name,options.merge(class:klass))
      end
    end
  end
  
  # creates a submit button with btn, post casses appended and puts to a form-group submit
  def submit(label,options={})
    @template.content_tag :div, class: "form-group submit" do
      klass=((options[:class]||"").split(" ")+["btn form-control post"]).join(" ")
      super(label,options.merge(class:klass))
    end
  end
end