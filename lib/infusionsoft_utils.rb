module InfusionsoftUtils

  DATE_FORMAT = "%Y-%m-%d"
 
  def self.update_contact(subscription)
    update_contact_by_user(subscription.user, subscription)
  end
  
  def self.get_infusionsoft_country(country)
    unless country.nil?
      if country == "US" || country == "USA"
        country = "United States"
      elsif country == "UK"
        country = "United Kingdom"
      end
    end
    return country
  end

  def self.update_contact_by_user(user, subscription)
    # Get the user's email
    email = user.email
    
    # Collect the fields to push
    fields = {:_SherlockDocsID => user.id, 
              :Email => user.email,
              :_SigninCount0 => user.sign_in_count,
              :_LastSignDate => get_formatted_date(user.last_sign_in_at),
              :_SherlockDocsDateCreated => get_formatted_date(user.created_at),
              :_Product => subscription.product_handle,
              :_PeriodEndsAt => get_formatted_date(subscription.period_ends_at),
              :_CasesAllowed => subscription.cases_max,
              :_CasesCreatedInPeriod => subscription.cases_count,
              :_Status => subscription.status
             }
             
    unless user.company_name.blank?
      fields[:Company] = user.company_name
      fields[:FirstName] = user.first_name
      fields[:LastName] = user.last_name
    end

    user_address = user.user_address
    unless user_address.nil?
      # Set the address fields
      fields[:StreetAddress1] = user_address.address unless user_address.address.blank?
      fields[:City] = user_address.city unless user_address.city.blank?
      fields[:State] = user_address.state unless user_address.state.blank?
      fields[:PostalCode] = user_address.zip unless user_address.zip.blank?

      infusionsoft_country = get_infusionsoft_country(user_address.country)
      fields[:Country] = infusionsoft_country unless infusionsoft_country.blank?

      unless user_address.phone.blank?
        fields[:Phone1] = user_address.phone
        fields[:Phone1Type] = "Work"
      end
      
    end

    Rails.logger.info "INFUSIONSOFT > Status change fields: #{fields}"
    
    # Check whether it's existing
    contacts = Infusionsoft.contact_find_by_email(email, [:Id])
    if contacts.nil?
      Rails.logger.error "INFUSIONSOFT > Could not get contacts for #{email}"
    else
      Rails.logger.info "INFUSIONSOFT > Contacts found: #{contacts}"
      size = contacts.length
      if size == 0
        # New contact, create it
        new_contact_id = Infusionsoft.contact_add(fields)
        Rails.logger.info "INFUSIONSOFT > Contact created, email: #{email}, id: #{new_contact_id}"
      else
        # Existing contact
        contact_id = -1
        if size > 1
          # Duplicated contacts, find the latest one
          contacts.each do |contact|
            existing_contact_id = contact["Id"]
            if existing_contact_id > contact_id
              contact_id = existing_contact_id
            end
          end
          
          # Log the older ones for removal 
          contacts.each do |contact|
            existing_contact_id = contact["Id"]
            if existing_contact_id != contact_id
              Rails.logger.warn "INFUSIONSOFT > Duplicated contact found, remove the older one: #{existing_contact_id}, email: #{email}"
            end
          end
        else
          # Only one found, use it
          contact_id = contacts[0]["Id"]
        end
        
        # Update contact
        updated_contact_id = Infusionsoft.contact_update(contact_id, fields)
        if updated_contact_id.blank?
          Rails.logger.error "INFUSIONSOFT > Could not update contact, email: #{email}, id: #{contact_id}"
        else
          Rails.logger.info "INFUSIONSOFT > Contact updated, email: #{email}, id: #{contact_id}"
        end
        
      end
    end
  end
  
  private
  
  def self.get_formatted_date(date)
     date.strftime(DATE_FORMAT)
  end
  
end