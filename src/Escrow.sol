// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./EscrowFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EscrowContract {
    address public escrowFactoryAddr;
    EscrowFactoryContract public escrowFactoryContract;

    // Declaring the state variables
    address payable public buyer;
    address payable public seller;
    // address payable public arbiter;
    // Declaring the object of the enumerator
    uint256 public adId;
    uint256 public value;

    State public state;

    address public usdtAddress; // Address of the USDT contract
    IERC20 public usdtToken; // Interface for interacting with USDT


    constructor(
        uint256 _value,
        address payable _buyer,
        address payable _seller,
        uint256 _adId,
        //address _usdtAddress,
        address _escrowFactoryAddr
    ) {
        // Assigning the values of the state variables
        //arbiter = payable(msg.sender);
        value = _value;
        buyer = _buyer;
        seller = _seller;
        adId = _adId;
        escrowFactoryAddr = _escrowFactoryAddr;

        // usdtAddress = _usdtAddress;
        // usdtToken = IERC20(_usdtAddress);

        state = State.await_deposit;
    }

    // Defining a enumerator 'State'
    enum State {
        // Following are the data members
        await_deposit,
        await_confirmation,
        await_dispute, //dispute is called by the dispute contract
        completed //means bank Transfer Verified by the seller
    }

    //user control
    // Defining function modifier 'instate'
    modifier instate(State expected_state) {
        require(state == expected_state);
        _;
    }
    modifier onlyBuyer() {
        require(msg.sender != seller);
        _;
    }
    modifier onlyDispute() {
        EscrowFactoryContract escrowFac = EscrowFactoryContract(
            escrowFactoryAddr
        );
        require(
            msg.sender == escrowFac.getDispute(),
            "Only the dispute address can call this function"
        );
        _;
    }

    modifier onlyListing() {
        EscrowFactoryContract escrowF = EscrowFactoryContract(
            escrowFactoryAddr
        );
        require(
            msg.sender == escrowF.getListing(),
            "Only the listing address can call this function"
        );
        _;
    }
///////////
    // event TokenTransferred(IERC20 token, address to, uint256 amount);
   
    // function getBalance(IERC20 tokenAddress) public view returns(uint256) {
    //     return tokenAddress.balanceOf(address(this));
    // }
   
    // function withdrawERC20Token(IERC20 tokenAddress) public {
    //     require(amount <= tokenAddress.balanceOf(address(this)), "Insufficient token balance");
    //     tokenAddress.transfer(msg.sender, value);
    
    //     emit TokenTransferred(tokenAddress, msg.sender, amount);   
    // }
    error TranferFailed();
    function deposit(address token) public payable onlyBuyer instate(State.await_deposit) returns(bool) {
        // s_balances[msg.token][token]+=amount;
        bool success = IERC20(token).transferFrom(
            seller,
            address(this),
            value
        );

        require(success, "Transaction was not successful");
        // if(!success) revert TransferFailed();
        return success;
    }

    function depositUSDT() public {
        require(usdtToken.transferFrom(buyer, address(this), value), "Transfer failed");
        // Now, 'amount' of USDT is stored in this contract's balance.
    }

    // function deposit() public payable onlyBuyer inState(State.Created) {
    //     require(
    //         msg.value == value,
    //         "Deposit amount must match the escrow value."
    //     );
    //     emit FundsDeposited(msg.sender, msg.value);
    //     state = State.Locked;
    // }

    //Confirm payment function will trasnfer the crypto funds to the buyer when Seller Confirms the payment
    // from escrow contract send funds to the buyer

    function buyerTransfer()
        public
        payable
        onlyListing
        instate(State.await_confirmation)
    {
        // seller.transfer(value); //transfer to buyer
        usdtToken.transfer(buyer, value);

        state = State.completed;
    }

    function compareStrings(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    //Dispute Transfer function can only be called by the dispute contract
    //b for buyer, s for seller
    function disputeTransfer(
        string calldata winner
    ) public onlyDispute instate(State.await_confirmation) {
        if (compareStrings(winner, "s")) {
            //send funds to seller
            state = State.completed;
        } else {
            //winner is b, send funds to buyer
            state = State.completed;
        }
    }
}
//how to send the funds from buyerinto the escrow contract
//how to send the funds from contract
