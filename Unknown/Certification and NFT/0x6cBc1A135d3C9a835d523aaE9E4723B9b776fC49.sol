['pragma solidity ^0.4.11;\n', '\n', '/**\n', '* @author Jefferson Davis\n', '* StakePool_ICO.sol creates the client&#39;s token for crowdsale and allows for subsequent token sales and minting of tokens\n', '*   In addition, there is a quarterly dividend payout triggered by the owner, plus creates a transaction record prior to payout\n', '*   Crowdsale contracts edited from original contract code at https://www.ethereum.org/crowdsale#crowdfund-your-idea\n', '*   Additional crowdsale contracts, functions, libraries from OpenZeppelin\n', '*       at https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token\n', '*   Token contract edited from original contract code at https://www.ethereum.org/token\n', '*   ERC20 interface and certain token functions adapted from https://github.com/ConsenSys/Tokens\n', '**/\n', '\n', 'contract ERC20 {\n', '\t//Sets events and functions for ERC20 token\n', '\tevent Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\tevent Transfer(address indexed _from, address indexed _to, uint _value);\n', '\t\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '\tfunction approve(address _spender, uint _value) returns (bool success);\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '}\n', '\n', '\n', 'contract Owned {\n', '\t//Public variable\n', '    address public owner;\n', '\n', '\t//Sets contract creator as the owner\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\t\n', '\t//Sets onlyOwner modifier for specified functions\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\t//Allows for transfer of contract ownership\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }  \n', '\n', '    function div(uint256 a, uint256 b) internal returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '  \n', '    function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '}\n', '\n', '\n', 'contract StakePool is ERC20, Owned {\n', '     //Applies SafeMath library to uint256 operations \n', '    using SafeMath for uint256;\n', '\n', '\t//Public variables\n', '\tstring public name; \n', '\tstring public symbol; \n', '\tuint256 public decimals;  \n', '    uint256 public initialSupply; \n', '\tuint256 public totalSupply; \n', '\n', '    //Variables\n', '    uint256 multiplier; \n', '\t\n', '\t//Creates arrays for balances\n', '    mapping (address => uint256) balance;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    //Creates modifier to prevent short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        if(msg.data.length < size + 4) revert();\n', '        _;\n', '    }\n', '\n', '\t//Constructor\n', '\tfunction StakePool(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier, uint256 initialAmount) {\n', '\t\tname = tokenName; \n', '\t\tsymbol = tokenSymbol; \n', '\t\tdecimals = decimalUnits; \n', '        multiplier = decimalMultiplier; \n', '        initialSupply = initialAmount; \n', '\t\ttotalSupply = initialSupply;  \n', '\t}\n', '\t\n', '\t//Provides the remaining balance of approved tokens from function approve \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '\t//Allows for a certain amount of tokens to be spent on behalf of the account owner\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        uint256 amount = _value.mul(multiplier); \n', '        allowed[msg.sender][_spender] = amount;\n', '        Approval(msg.sender, _spender, amount);\n', '        return true;\n', '    }\n', '\n', '\t//Returns the account balance \n', '    function balanceOf(address _owner) constant returns (uint256 remainingBalance) {\n', '        return balance[_owner];\n', '    }\n', '\n', '    //Allows contract owner to mint new tokens, prevents numerical overflow\n', '\tfunction mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {\n', '        uint256 addTokens = mintedAmount.mul(multiplier); \n', '\t\tif ((totalSupply + addTokens) < totalSupply) {\n', '\t\t\trevert(); \n', '\t\t} else {\n', '\t\t\tbalance[target] += addTokens;\n', '\t\t\ttotalSupply += addTokens;\n', '\t\t\tTransfer(0, target, addTokens);\n', '\t\t\treturn true; \n', '\t\t}\n', '\t}\n', '\n', '\t//Sends tokens from sender&#39;s account\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '        uint256 amount = _value.mul(multiplier); \n', '        if (balance[msg.sender] >= amount && balance[_to] + amount > balance[_to]) {\n', '            balance[msg.sender] -= amount;\n', '            balance[_to] += amount;\n', '            Transfer(msg.sender, _to, amount);\n', '            return true;\n', '        } else { \n', '\t\t\treturn false; \n', '\t\t}\n', '    }\n', '\t\n', '\t//Transfers tokens from an approved account \n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {\n', '        uint256 amount = _value.mul(multiplier); \n', '        if (balance[_from] >= amount && allowed[_from][msg.sender] >= amount && balance[_to] + amount > balance[_to]) {\n', '            balance[_to] += amount;\n', '            balance[_from] -= amount;\n', '            allowed[_from][msg.sender] -= amount;\n', '            Transfer(_from, _to, amount);\n', '            return true;\n', '        } else { \n', '\t\t\treturn false; \n', '\t\t}\n', '    }\n', '}\n', '\n', '\n', 'contract StakePoolICO is Owned, StakePool {\n', '    //Applies SafeMath library to uint256 operations \n', '    using SafeMath for uint256;\n', '\n', '    //Public Variables\n', '    address public multiSigWallet;                  \n', '    uint256 public amountRaised; \n', '    uint256 public dividendPayment;\n', '    uint256 public numberOfRecordEntries; \n', '    uint256 public numberOfTokenHolders; \n', '    uint256 public startTime; \n', '    uint256 public stopTime; \n', '    uint256 public hardcap; \n', '    uint256 public price;                            \n', '\n', '    //Variables\n', '    address[] recordTokenHolders; \n', '    address[] tokenHolders; \n', '    bool crowdsaleClosed = true; \n', '    mapping (address => uint256) recordBalance; \n', '    mapping (address => uint256) recordTokenHolderID;      \n', '    mapping (address => uint256) tokenHolderID;               \n', '    string tokenName = "StakePool"; \n', '    string tokenSymbol = "POOL"; \n', '    uint256 initialTokens = 20000000000000000; \n', '    uint256 multiplier = 10000000000; \n', '    uint8 decimalUnits = 8;  \n', '\n', '   \t//Initializes the token\n', '\tfunction StakePoolICO() \n', '    \tStakePool(tokenName, tokenSymbol, decimalUnits, multiplier, initialTokens) {\n', '            balance[msg.sender] = initialTokens;     \n', '            Transfer(0, msg.sender, initialTokens);    \n', '            multiSigWallet = msg.sender;        \n', '            hardcap = 20100000000000000;    \n', '            setPrice(20); \n', '            dividendPayment = 50000000000000; \n', '            recordTokenHolders.length = 2; \n', '            tokenHolders.length = 2; \n', '            tokenHolders[1] = msg.sender; \n', '            numberOfTokenHolders++; \n', '    }\n', '\n', '    //Fallback function creates tokens and sends to investor when crowdsale is open\n', '    function () payable {\n', '        require((!crowdsaleClosed) \n', '            && (now < stopTime) \n', '            && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap)); \n', '        address recipient = msg.sender; \n', '        amountRaised = amountRaised.add(msg.value.div(1 ether)); \n', '        uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);\n', '        totalSupply = totalSupply.add(tokens);\n', '        balance[recipient] = balance[recipient].add(tokens);\n', '        require(multiSigWallet.send(msg.value)); \n', '        Transfer(0, recipient, tokens);\n', '        if (tokenHolderID[recipient] == 0) {\n', '            addTokenHolder(recipient); \n', '        }\n', '    }   \n', '\n', '    //Adds an address to the recorrdEntry list\n', '    function addRecordEntry(address account) internal {\n', '        if (recordTokenHolderID[account] == 0) {\n', '            recordTokenHolderID[account] = recordTokenHolders.length; \n', '            recordTokenHolders.length++; \n', '            recordTokenHolders[recordTokenHolders.length.sub(1)] = account; \n', '            numberOfRecordEntries++;\n', '        }\n', '    }\n', '\n', '    //Adds an address to the tokenHolders list \n', '    function addTokenHolder(address account) returns (bool success) {\n', '        bool status = false; \n', '        if (balance[account] != 0) {\n', '            tokenHolderID[account] = tokenHolders.length;\n', '            tokenHolders.length++;\n', '            tokenHolders[tokenHolders.length.sub(1)] = account; \n', '            numberOfTokenHolders++;\n', '            status = true; \n', '        }\n', '        return status; \n', '    }  \n', '\n', '    //Allows the owner to create an record of token owners and their balances\n', '    function createRecord() internal {\n', '        for (uint i = 0; i < (tokenHolders.length.sub(1)); i++ ) {\n', '            address holder = getTokenHolder(i);\n', '            uint256 holderBal = balanceOf(holder); \n', '            addRecordEntry(holder); \n', '            recordBalance[holder] = holderBal; \n', '        }\n', '    }\n', '\n', '    //Returns the current price of the token for the crowdsale\n', '    function getPrice() returns (uint256 result) {\n', '        return price;\n', '    }\n', '\n', '    //Returns record contents\n', '    function getRecordBalance(address record) constant returns (uint256) {\n', '        return recordBalance[record]; \n', '    }\n', '\n', '    //Returns the address of a specific index value\n', '    function getRecordHolder(uint256 index) constant returns (address) {\n', '        return address(recordTokenHolders[index.add(1)]); \n', '    }\n', '\n', '    //Returns time remaining on crowdsale\n', '    function getRemainingTime() constant returns (uint256) {\n', '        return stopTime; \n', '    }\n', '\n', '    //Returns the address of a specific index value\n', '\tfunction getTokenHolder(uint256 index) constant returns (address) {\n', '\t\treturn address(tokenHolders[index.add(1)]);\n', '\t}\n', '\n', '    //Pays out dividends to tokens holders of record, based on 500,000 token payment\n', '    function payOutDividend() onlyOwner returns (bool success) { \n', '        createRecord(); \n', '        uint256 volume = totalSupply; \n', '        for (uint i = 0; i < (tokenHolders.length.sub(1)); i++) {\n', '            address payee = getTokenHolder(i); \n', '            uint256 stake = volume.div(dividendPayment.div(multiplier));    \n', '            uint256 dividendPayout = balanceOf(payee).div(stake).mul(multiplier); \n', '            balance[payee] = balance[payee].add(dividendPayout);\n', '            totalSupply = totalSupply.add(dividendPayout); \n', '            Transfer(0, payee, dividendPayout);\n', '        }\n', '        return true; \n', '    }\n', '\n', '    //Sets the multisig wallet for a crowdsale\n', '    function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {\n', '        multiSigWallet = wallet; \n', '        return true; \n', '    }\n', '\n', '    //Sets the token price \n', '    function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {\n', '        require(newPriceperEther > 0); \n', '        price = newPriceperEther; \n', '        return price; \n', '    }\n', '\n', '    //Allows owner to start the crowdsale from the time of execution until a specified stopTime\n', '    function startSale(uint256 saleStart, uint256 saleStop) onlyOwner returns (bool success) {\n', '        require(saleStop > now);     \n', '        startTime = saleStart; \n', '        stopTime = saleStop; \n', '        crowdsaleClosed = false; \n', '        return true; \n', '    }\n', '\n', '    //Allows owner to stop the crowdsale immediately\n', '    function stopSale() onlyOwner returns (bool success) {\n', '        stopTime = now; \n', '        crowdsaleClosed = true;\n', '        return true; \n', '    }\n', '\n', '}']