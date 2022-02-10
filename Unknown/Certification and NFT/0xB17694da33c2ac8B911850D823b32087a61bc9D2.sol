['pragma solidity ^0.4.11;\n', '\n', '\n', 'contract ERC20 {\n', '\t//Sets events and functions for ERC20 token\n', '\tevent Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\tevent Transfer(address indexed _from, address indexed _to, uint _value);\n', '\t\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '\tfunction approve(address _spender, uint _value) returns (bool success);\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '}\n', '\n', '\n', 'contract Owned {\n', '\t//Public variable\n', '    address public owner;\n', '\n', '\t//Sets contract creator as the owner\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\t\n', '\t//Sets onlyOwner modifier for specified functions\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '\t//Allows for transfer of contract ownership\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract TokenWithMint is ERC20, Owned {\n', '\t//Public variables\n', '\tstring public name; \n', '\tstring public symbol; \n', '\tuint256 public decimals;  \n', '    uint256 multiplier; \n', '\tuint256 public totalSupply; \n', '\t\n', '\t//Creates arrays for balances\n', '    mapping (address => uint256) balance;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    //Creates modifier to prevent short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        if(msg.data.length < size + 4) throw;\n', '        _;\n', '    }\n', '\n', '\t//Constructor\n', '\tfunction TokenWithMint(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier) {\n', '\t\tname = tokenName; \n', '\t\tsymbol = tokenSymbol; \n', '\t\tdecimals = decimalUnits; \n', '        multiplier = decimalMultiplier; \n', '\t\ttotalSupply = 0;  \n', '\t}\n', '\t\n', '\t//Provides the remaining balance of approved tokens from function approve \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '\t//Allows for a certain amount of tokens to be spent on behalf of the account owner\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\t//Returns the account balance \n', '    function balanceOf(address _owner) constant returns (uint256 remainingBalance) {\n', '        return balance[_owner];\n', '    }\n', '\n', '    //Allows contract owner to mint new tokens, prevents numerical overflow\n', '\tfunction mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {\n', '\t\tif ((totalSupply + mintedAmount) < totalSupply) {\n', '\t\t\tthrow; \n', '\t\t} else {\n', '            uint256 addTokens = mintedAmount * multiplier; \n', '\t\t\tbalance[target] += addTokens;\n', '\t\t\ttotalSupply += addTokens;\n', '\t\t\tTransfer(0, target, addTokens);\n', '\t\t\treturn true; \n', '\t\t}\n', '\t}\n', '\n', '\t//Sends tokens from sender&#39;s account\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '        if (balance[msg.sender] >= _value && balance[_to] + _value > balance[_to]) {\n', '            balance[msg.sender] -= _value;\n', '            balance[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { \n', '\t\t\treturn false; \n', '\t\t}\n', '    }\n', '\t\n', '\t//Transfers tokens from an approved account \n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {\n', '        if (balance[_from] >= _value && allowed[_from][msg.sender] >= _value && balance[_to] + _value > balance[_to]) {\n', '            balance[_to] += _value;\n', '            balance[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { \n', '\t\t\treturn false; \n', '\t\t}\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }  \n', '\n', '    function div(uint256 a, uint256 b) internal returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '  \n', '    function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '}\n', '\n', '\n', 'contract PretherICO is Owned, TokenWithMint {\n', '    //Applies SafeMath library to uint256 operations \n', '    using SafeMath for uint256;\n', '\n', '    //Public Variables\n', '    address public multiSigWallet;                  \n', '    bool crowdsaleClosed = true;                    //initializes as true, requires owner to turn on crowdsale\n', '    string tokenName = "Prether"; \n', '    string tokenSymbol = "PTH"; \n', '    uint256 public amountRaised; \n', '    uint256 public deadline; \n', '    uint256 multiplier = 1; \n', '    uint256 public price;                           \n', '    uint8 decimalUnits = 0;   \n', '    \n', '\n', '   \t//Initializes the token\n', '\tfunction PretherICO() \n', '    \tTokenWithMint(tokenName, tokenSymbol, decimalUnits, multiplier) {  \n', '            multiSigWallet = msg.sender;          \n', '    }\n', '\n', '    //Fallback function creates tokens and sends to investor when crowdsale is open\n', '    function () payable {\n', '        require(!crowdsaleClosed && (now < deadline)); \n', '        address recipient = msg.sender; \n', '        amountRaised = amountRaised + msg.value; \n', '        uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);\n', '        totalSupply = totalSupply.add(tokens);\n', '        balance[recipient] = balance[recipient].add(tokens);\n', '        require(multiSigWallet.send(msg.value)); \n', '        Transfer(0, recipient, tokens);\n', '    }   \n', '\n', '    //Returns the current price of the token for the crowdsale\n', '    function getPrice() returns (uint256 result) {\n', '        return price;\n', '    }\n', '\n', '    //Returns time remaining on crowdsale\n', '    function getRemainingTime() constant returns (uint256) {\n', '        return deadline; \n', '    }\n', '\n', '    //Returns the current status of the crowdsale\n', '    function getSaleStatus() constant returns (bool) {\n', '        bool status = false; \n', '        if (crowdsaleClosed == false) {\n', '            status = true; \n', '        }\n', '        return status; \n', '    }\n', '\n', '    //Sets the multisig wallet for a crowdsale\n', '    function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {\n', '        multiSigWallet = wallet; \n', '        return true; \n', '    }\n', '\n', '    //Sets the token price \n', '    function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {\n', '        if (newPriceperEther <= 0) throw;  //checks for valid inputs\n', '        price = newPriceperEther; \n', '        return price; \n', '    }\n', '\n', '    //Allows owner to start the crowdsale from the time of execution until a specified deadline\n', '    function startSale(uint256 price, uint256 hoursToEnd) onlyOwner returns (bool success) {\n', '        if ((hoursToEnd < 1 )) throw;     //checks for valid inputs \n', '        price = setPrice(price); \n', '        deadline = now + hoursToEnd * 1 hours; \n', '        crowdsaleClosed = false; \n', '        return true; \n', '    }\n', '\n', '    //Allows owner to start an unlimited crowdsale with no deadline or funding goal\n', '    function startUnlimitedSale(uint256 price) onlyOwner returns (bool success) {\n', '        price = setPrice(price); \n', '        deadline = 9999999999;\n', '        crowdsaleClosed = false; \n', '        return true; \n', '    }\n', '\n', '    //Allows owner to stop the crowdsale immediately\n', '    function stopSale() onlyOwner returns (bool success) {\n', '        deadline = now; \n', '        crowdsaleClosed = true;\n', '        return true; \n', '    }\n', '\n', '}']