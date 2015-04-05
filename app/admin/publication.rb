ActiveAdmin.register Publication do
  permit_params :name, :image, :website, :description, offer_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :image do |publication|
      if publication.image?
        image_tag(publication.image.url(:thumb), height: '100')
      else
        content_tag(:span, 'None')
      end
    end
    column :website do |publication|
      link_to publication.website, publication.website
    end
    column 'Offers' do |publication|
      (publication.offers.map { |offer| link_to offer.name, admin_offer_path(offer) }).
      join(', ').html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :image do
        if publication.image?
          image_tag(publication.image.url)
        else
          content_tag(:span, 'None')
        end
      end
      row :website do
        link_to publication.website, publication.website
      end
      row 'Offers' do
        (publication.offers.map { |offer| link_to offer.name, admin_offer_path(offer) }).
        join(', ').html_safe
      end
      row :description do
        publication.description.html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Product Details" do
      f.input :name, input_html: { rows: 1 }
      f.input :image, as: :file, hint: if f.publication.image?
        image_tag(f.publication.image.url)
      else
        content_tag(:span, 'Please upload an image')
      end
      f.input :website, as: :url, input_html: { rows: 1 }
      f.input :offers
      f.input :description, input_html: { :class => 'tinymce' }
    end
    f.actions
  end

end