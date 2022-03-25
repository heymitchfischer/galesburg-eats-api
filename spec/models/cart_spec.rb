require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '#add_item' do
    subject { cart.add_item(item) }

    let(:cart)       { described_class.new(user) }
    let(:user)       { double(User, id: 1) }
    let(:item)       { double(MenuItem, id: 5, business: business_1) }
    let(:business_1) { double(Business, id: 1) }
    let(:business_2) { double(Business, id: 2) }
    let(:business_3) { double(Business, id: 3) }
    
    before do
      allow(user).to receive(:registered?).and_return(registered)
      allow(CartedItem).to receive(:where).and_return(items_in_cart)
    end
    
    context 'when user does not currently have items in their cart' do
      let(:items_in_cart) { [] }
      
      context 'when user is registered' do
        let(:registered) { true }

        it 'creates a new item in the cart for a registered user' do
          expect(CartedItem).to receive(:create!).with({ user_id: user.id, menu_item_id: item.id })
          subject
        end
      end

      context 'when user is a guest' do
        let(:registered) { false }

        it 'creates a new item in the cart for a guest user' do
          expect(CartedItem).to receive(:create!).with({ guest_user_id: user.id, menu_item_id: item.id })
          subject
        end
      end
    end

    context 'when user has items in their cart' do
      let(:items_in_cart) { [cart_item_1, cart_item_2] }

      context 'when the new item is not from the same business' do
        let(:registered)  { true }
        let(:cart_item_1) { double(CartedItem, business: business_2) }
        let(:cart_item_2) { double(CartedItem, business: business_2) }

        it 'raises an error and does not allow the user to add the item' do
          expect(CartedItem).not_to receive(:create!)
          expect { subject }.to raise_error(CartError, Cart::NEW_ITEM_BUSINESS_ID_DOES_NOT_MATCH)
        end
      end

      context 'when the current cart items are not all from the same business' do
        let(:registered)  { true }
        let(:cart_item_1) { double(CartedItem, business: business_2) }
        let(:cart_item_2) { double(CartedItem, business: business_3) }

        it 'raises an error and does not allow the user to add the item' do
          expect(CartedItem).not_to receive(:create!)
          expect { subject }.to raise_error(CartError, Cart::BUSINESS_IDS_IN_CART_DO_NOT_MATCH)
        end
      end

      context 'when the new item is from the same business' do
        let(:cart_item_1) { double(CartedItem, business: business_1) }
        let(:cart_item_2) { double(CartedItem, business: business_1) }

        context 'when user is registered' do
          let(:registered) { true }
  
          it 'creates a new item in the cart for a registered user' do
            expect(CartedItem).to receive(:create!).with({ user_id: user.id, menu_item_id: item.id })
            subject
          end
        end
  
        context 'when user is a guest' do
          let(:registered) { false }
  
          it 'creates a new item in the cart for a guest user' do
            expect(CartedItem).to receive(:create!).with({ guest_user_id: user.id, menu_item_id: item.id })
            subject
          end
        end
      end
    end
  end

  describe '#remove_item' do
    subject { cart.remove_item(cart_item) }

    let(:cart)      { described_class.new(user) }
    let(:user)      { double(User, id: 1) }
    let(:cart_item) { double(CartedItem) }
    
    before do
      allow(user).to receive(:registered?).and_return(true)
      allow(CartedItem).to receive(:where).and_return(items_in_cart)
    end

    context 'when user does not have the item in their cart' do
      let(:items_in_cart) { [] }

      it 'raises an error and does modify the item' do
        expect(cart_item).not_to receive(:update)
        expect { subject }.to raise_error(CartError, Cart::ITEM_IS_NOT_IN_CART)
      end
    end

    context 'when user has the item in their cart' do
      let(:items_in_cart) { [cart_item] }

      it 'raises an error and does modify the item' do
        expect(cart_item).to receive(:update).with({ removed: true })
        subject
      end
    end
  end

  describe '#checkout' do
    subject { cart.checkout() }

    let(:cart)       { described_class.new(user) }
    let(:user)       { double(User, id: 1) }
    
    before do
      allow(user).to receive(:registered?).and_return(registered)
      allow(CartedItem).to receive(:where).and_return(items_in_cart)
    end
    
    context 'when user does not have items in their cart' do
      let(:items_in_cart) { [] }
      let(:registered)    { true }

      it 'raises an error and does not allow the user to checkout' do
        expect(Order).not_to receive(:create!)
        expect { subject }.to raise_error(CartError, Cart::NO_ITEMS_IN_CART_TO_CHECKOUT)
      end
    end

    context 'when user has items in their cart' do
      let(:items_in_cart) { [cart_item_1, cart_item_2] }
      let(:cart_item_1)   { double(CartedItem, menu_item: menu_item, business: business) }
      let(:cart_item_2)   { double(CartedItem, menu_item: menu_item, business: business) }
      let(:menu_item)     { double(MenuItem, price: 1000) }
      let(:business)      { double(Business, id: 1) }
      let(:order)         { double(Order, id: 2) }

      before do
        allow(Order).to receive(:create!).and_return(order)
      end

      context 'when user is registered' do
        let(:registered) { true }

        it 'creates a new user order and updates the items' do
          expect(Order).to receive(:create!).with({ user_id: user.id, business_id: business.id, total_price: 2000 })
          expect(cart_item_1).to receive(:update).with({ order_id: order.id })
          expect(cart_item_2).to receive(:update).with({ order_id: order.id })
          subject
        end
      end

      context 'when user is a guest' do
        let(:registered) { false }

        it 'creates a new guest order and updates the items' do
          expect(Order).to receive(:create!).with({ guest_user_id: user.id, business_id: business.id, total_price: 2000 })
          expect(cart_item_1).to receive(:update).with({ order_id: order.id })
          expect(cart_item_2).to receive(:update).with({ order_id: order.id })
          subject
        end
      end
    end
  end
end
