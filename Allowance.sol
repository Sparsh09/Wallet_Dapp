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