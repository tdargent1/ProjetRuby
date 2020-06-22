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
            card_title += t('user.add_movie_to_library', user_name: User.find(self.to_user_id).name)
        elsif self.waiting?
            card_title += t('user.user_ask_lent_to_user',
                            from_user_name: User.find(self.from_user_id).name,
                            to_user_name: User.find(self.to_user_id).name
            )
            requested_action = true;
        elsif self.accepted?
            card_title += t('user.user_lent_to_user',
                            to_user_name: User.find(self.to_user_id).name,
                            from_user_name: User.find(self.from_user_id).name
            )
        elsif self.refused?
            card_title += t('user.refused_lent_ask',
                            to_user_name: User.find(self.to_user_id).name,
                            from_user_name: User.find(self.from_user_id).name
            )
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
  