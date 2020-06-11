class UserAction < ApplicationRecord
    include AASM

    belongs_to :to_user, class_name: 'User', :foreign_key => :to_user_id
    belongs_to :from_user, class_name: 'User', :foreign_key => :from_user_id

    aasm :column => :status do
        state :created, initial: true
        state :waiting
        state :accepted
        state :refused
    
        event :refuse do
          transitions from: :waiting, to: :refused
        end
    
        event :accept do
          transitions from: [:waiting, :created], to: :accepted
        end
    
        event :wait do
          transitions from: :created, to: :waiting
        end
    end

    def card_title(user_id)
        card_title = ""
        requested_action = false

        if self.from_user_id == self.to_user_id
            card_title += "#{User.find(self.to_user_id).name} a ajouté un film à sa vidéothèque"
        elsif self.waiting?
            card_title += "#{User.find(self.from_user_id).name} a fait une demande de prêt à #{User.find(self.to_user_id).name}"
            requested_action = true;
        elsif self.accepted?
            card_title += "#{User.find(self.to_user_id).name} a fait un prêt à #{User.find(self.from_user_id).name}"
        elsif self.refused?
            card_title += "#{User.find(self.to_user_id).name} a refusé la demande de prêt de #{User.find(self.from_user_id).name}"
        end

        status = self.waiting? ? "warning" : ( self.accepted? ? "success" : ( self.refused? ? "danger" : "primary" ) )

        return {title: card_title, status: status, requested_action: requested_action}
    end

    def status_to_text
        return "Créé" if self.created?
        return "En attente" if self.waiting?
        return "Accepté" if self.accepted?
        return "Refusé" if self.refused?
    end
    
end
  