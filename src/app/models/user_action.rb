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
        
        if self.from_user_id.nil?
            card_title += "Vous avez ajouté un film à votre vidéothèque"
        elsif self.to_user_id == user_id
            card_title += self.waiting? ? User.find(from_user_id).name.to_s + " vous a envoyé une demande d'emprunt" : ( self.accepted? ? "Vous avez fait un prêt à " + User.find(from_user_id).name.to_s : "Vous avez refusé le prêt de " + User.find(from_user_id).name.to_s )
            requested_action = true if self.waiting?
        else
            card_title += User.find(from_user_id).name.to_s
            card_title += self.waiting? ? " est en attente de validation de votre demande de prêt" : ( self.accepted? ? " a validé votre demande de prêt" : " a refusé votre demande de prêt" )
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
  