/*
  Authorship: All credit for this code in this file goes to Etienne Dusseault.
              You can find the full document here: 
              https://medium.com/coinmonks/introduction-to-solidity-programming-and-smart-contracts-for-complete-beginners-eb46472058cf
  
  I have just added a few lines to help me to understand. In particular, Events help to debug. 
  
  This code is run without any issues on a compiler "0.4.25-nightly.2018.8.3+commit.04efbc9e.Emscripten.clang" on Remix.
*/

pragma solidity ^0.4.24;

contract Will{
    
    address owner;
    uint fortune;
    bool isDeceased;
    event beforeTransfer(uint balance, uint inheritance_value);
    event afterTransfer(uint balance);
    
    constructor() public payable{
        owner = msg.sender;
        fortune = msg.value;
        isDeceased = false;
    }
    
    modifier onlyOwner{
        require (msg.sender == owner);
        _;  // This takes it to the actual function. 
    }
    
    modifier mustBeDeceased{
        require (isDeceased == true);
        _;
    }
    
    address[] wallets;
    
    mapping (address => uint) inheritance;
    
    function setInheritance(address _wallet, uint _inheritance) public onlyOwner{
        wallets.push(_wallet);
        inheritance[_wallet] = _inheritance;
    }
    
    function payout() private mustBeDeceased{        
        for (uint i = 0; i < wallets.length; i++){
            emit beforeTransfer(fortune, inheritance[wallets[i]]);
            if(fortune >= inheritance[wallets[i]]){
                wallets[i].transfer(inheritance[wallets[i]]);
            }else{
                revert();
            }
        }
        emit afterTransfer(fortune);
    }
    
    function deceased() public onlyOwner{ // How a dead person calls this function remains questionable.
        isDeceased = true;
        payout();
    }
}

