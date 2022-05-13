//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;
import "./Allowance.sol";

contract Wallet is Allowance{

    event SpentMoney(address indexed _person, uint _amount);
    event MoneyReceived(uint _amount);

    function withdrawMoney(address payable _to , uint _amount) public ownerOrAllowed(_amount){
        require(_amount <= address(this).balance , "Amount should be less than equal to smart contact");
        if(owner() != msg.sender){
            reduceAllowance(_to , _amount);
        }
        emit SpentMoney(_to, _amount);
        _to.transfer(_amount);
        
    }
    function renounceOwnership() public view onlyOwner override{
        revert("Cannot renouce ownership");
    }

    receive() external payable { 
        emit MoneyReceived(msg.value);
     }

    fallback () external payable{ 
        emit MoneyReceived(msg.value);
     }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
}