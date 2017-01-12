class ContactsController < ApplicationController
    #GET request to /contact-us
    #Show new contact form
    def new
        @contact = Contact.new
    end
    
    # POST request /contacts
    def create
        #Mass assignment of form fields into Contact object
        @contact = Contact.new(contact_params)
          # Save Contact object to DB
        if @contact.save
         #Store form fields via params into variables
      
            name= params[:contact][:name]
            email= params[:contact][:email]
            body= params[:contact][:comments]
            #Variables into Contact Mailer email method
            ContactMailer.contact_email(name, email, body).deliver
            #Store success message in flash 
            #Redirect to new
            flash[:success] = "Message Sent!"
            redirect_to new_contact_path
        else
            #If contact object doesnt save
            #Error message in flash, go to new
            flash[:danger] = @contact.errors.full_messages.join(", ")
            redirect_to new_contact_path
        end
    end
    
    private
        # To collect data from form, use strong params
        # Whitelist form fields
        def contact_params
            params.require(:contact).permit(:name, :email, :comments)
        end    
end

