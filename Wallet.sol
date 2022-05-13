//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract Allowance is Ownable{
    
    using SafeMath for uint;

    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom , uint _oldAmount , uint _NewAmount);

    mapping(address => uint ) public allowance;

    function addAllowance(address _who, uint _amount) public onlyOwner{
        emit AllowanceChanged(_who ,msg.sender , allowance[_who] , _amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint _amount){
        require( owner() == msg.sender || allowance[msg.sender] >= _amount , "You are not allowed");
        _;
    }

    function reduceAllowance(address _to , uint _amount) internal{
        emit AllowanceChanged(_to , msg.sender , allowance[_to], allowance[_to].sub(_amount));
        allowance[_to] = allowance[_to].sub(_amount); 
        
    }

}

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