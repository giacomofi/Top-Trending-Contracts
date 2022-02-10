['pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '/**\n', '* privlocatum.sol build token for crowdsale and allows for subsequent token sales and minting of tokens\n', '**/\n', '\n', '\n', '\n', 'contract ERC20 {\n', '\n', '    //Sets events and functions for ERC20 token\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '\n', '    function approve(address _spender, uint _value) returns (bool success);\n', '\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract Owned {\n', '\n', '    //Public variable\n', '\n', '    address public owner;\n', '\n', '\n', '\n', '    //Sets contract creator as the owner\n', '\n', '    function Owned() {\n', '\n', '        owner = msg.sender;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Sets onlyOwner modifier for specified functions\n', '\n', '    modifier onlyOwner {\n', '\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows for transfer of contract ownership\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '\n', '        owner = newOwner;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '\n', '        uint256 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal returns (uint256) {\n', '\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\n', '        uint256 c = a / b;\n', '\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '\n', '        return a >= b ? a : b;\n', '\n', '    }\n', '\n', '\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '        return a >= b ? a : b;\n', '\n', '    }\n', '\n', '\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '\n', '        return a < b ? a : b;\n', '\n', '    }\n', '\n', '\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '        return a < b ? a : b;\n', '\n', '    }\n', '\n', '\n', '\n', '    function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '\n', '        uint256 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract privlocatum is ERC20, Owned {\n', '\n', '    //Applies SafeMath library to uint256 operations\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '\n', '    //Public variables\n', '\n', '    string public name;\n', '\n', '    string public symbol;\n', '\n', '    uint256 public decimals;\n', '\n', '    uint256 public totalSupply;\n', '\n', '\n', '\n', '    //Variables\n', '\n', '    uint256 multiplier;\n', '\n', '\n', '\n', '    //Creates arrays for balances\n', '\n', '    mapping (address => uint256) balance;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '\n', '    //Creates modifier to prevent short address attack\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '\n', '        if(msg.data.length < size + 4) revert();\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Constructor\n', '\n', '    function privlocatum(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier) {\n', '\n', '        name = tokenName;\n', '\n', '        symbol = tokenSymbol;\n', '\n', '        decimals = decimalUnits;\n', '\n', '        multiplier = decimalMultiplier;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Provides the remaining balance of approved tokens from function approve\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\n', '      return allowed[_owner][_spender];\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows for a certain amount of tokens to be spent on behalf of the account owner\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Returns the account balance\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 remainingBalance) {\n', '\n', '        return balance[_owner];\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows contract owner to mint new tokens, prevents numerical overflow\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {\n', '\n', '        require(mintedAmount > 0);\n', '\n', '        uint256 addTokens = mintedAmount;\n', '\n', '        balance[target] += addTokens;\n', '\n', '        totalSupply += addTokens;\n', '\n', '        Transfer(0, target, addTokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Sends tokens from sender&#39;s account\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '\n', '        if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {\n', '\n', '            balance[msg.sender] -= _value;\n', '\n', '            balance[_to] += _value;\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '\n', '            return true;\n', '\n', '        } else {\n', '\n', '            return false;\n', '\n', '        }\n', '\n', '    }\n', '\n', '\n', '    //Transfers tokens from an approved account\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {\n', '\n', '        if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {\n', '\n', '            balance[_to] += _value;\n', '\n', '            balance[_from] -= _value;\n', '\n', '            allowed[_from][msg.sender] -= _value;\n', '\n', '            Transfer(_from, _to, _value);\n', '\n', '            return true;\n', '\n', '        } else {\n', '\n', '            return false;\n', '\n', '        }\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract privlocatumICO is Owned, privlocatum {\n', '\n', '    //Applies SafeMath library to uint256 operations\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '\n', '    //Public Variables\n', '\n', '    address public multiSigWallet;\n', '\n', '    uint256 public amountRaised;\n', '\n', '    uint256 public startTime;\n', '\n', '    uint256 public stopTime;\n', '\n', '    uint256 public hardcap;\n', '\n', '    uint256 public price;\n', '\n', '\n', '\n', '    //Variables\n', '\n', '    bool crowdsaleClosed = true;\n', '\n', '    string tokenName = "Privlocatum";\n', '\n', '    string tokenSymbol = "PLT";\n', '\n', '    uint256 multiplier = 100000000;\n', '\n', '    uint8 decimalUnits = 8;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '    //Initializes the token\n', '\n', '    function privlocatumICO()\n', '\n', '        privlocatum(tokenName, tokenSymbol, decimalUnits, multiplier) {\n', '\n', '            multiSigWallet = msg.sender;\n', '\n', '            hardcap = 70000000;\n', '\n', '            hardcap = hardcap.mul(multiplier);\n', '\n', '    }\n', '\n', '\n', '\n', '    //Fallback function creates tokens and sends to investor when crowdsale is open\n', '\n', '    function () payable {\n', '\n', '        require(!crowdsaleClosed\n', '\n', '            && (now < stopTime)\n', '\n', '            && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap));\n', '\n', '        address recipient = msg.sender;\n', '\n', '        amountRaised = amountRaised.add(msg.value.div(1 ether));\n', '\n', '        uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);\n', '\n', '        totalSupply = totalSupply.add(tokens);\n', '\n', '        balance[recipient] = balance[recipient].add(tokens);\n', '\n', '        require(multiSigWallet.send(msg.value));\n', '\n', '        Transfer(0, recipient, tokens);\n', '\n', '    }\n', '\n', '\n', '\n', '    //Returns the current price of the token for the crowdsale\n', '\n', '    function getPrice() returns (uint256 result) {\n', '\n', '        return price;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Returns time remaining on crowdsale\n', '\n', '    function getRemainingTime() constant returns (uint256) {\n', '\n', '        return stopTime;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Set the sale hardcap amount\n', '\n', '    function setHardCapValue(uint256 newHardcap) onlyOwner returns (bool success) {\n', '\n', '        hardcap = newHardcap.mul(multiplier);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Sets the multisig wallet for a crowdsale\n', '\n', '    function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {\n', '\n', '        multiSigWallet = wallet;\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Sets the token price\n', '\n', '    function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {\n', '\n', '        require(newPriceperEther > 0);\n', '\n', '        price = newPriceperEther;\n', '\n', '        return price;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows owner to start the crowdsale from the time of execution until a specified stopTime\n', '\n', '    function startSale(uint256 saleStart, uint256 saleStop, uint256 salePrice, address setBeneficiary) onlyOwner returns (bool success) {\n', '\n', '        require(saleStop > now);\n', '\n', '        startTime = saleStart;\n', '\n', '        stopTime = saleStop;\n', '\n', '        crowdsaleClosed = false;\n', '\n', '        setPrice(salePrice);\n', '\n', '        setMultiSigWallet(setBeneficiary);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows owner to stop the crowdsale immediately\n', '\n', '    function stopSale() onlyOwner returns (bool success) {\n', '\n', '        stopTime = now;\n', '\n', '        crowdsaleClosed = true;\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '/**\n', '* privlocatum.sol build token for crowdsale and allows for subsequent token sales and minting of tokens\n', '**/\n', '\n', '\n', '\n', 'contract ERC20 {\n', '\n', '    //Sets events and functions for ERC20 token\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '\n', '    function approve(address _spender, uint _value) returns (bool success);\n', '\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract Owned {\n', '\n', '    //Public variable\n', '\n', '    address public owner;\n', '\n', '\n', '\n', '    //Sets contract creator as the owner\n', '\n', '    function Owned() {\n', '\n', '        owner = msg.sender;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Sets onlyOwner modifier for specified functions\n', '\n', '    modifier onlyOwner {\n', '\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows for transfer of contract ownership\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '\n', '        owner = newOwner;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '\n', '        uint256 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal returns (uint256) {\n', '\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\n', '        uint256 c = a / b;\n', '\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '\n', '        return a >= b ? a : b;\n', '\n', '    }\n', '\n', '\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '        return a >= b ? a : b;\n', '\n', '    }\n', '\n', '\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '\n', '        return a < b ? a : b;\n', '\n', '    }\n', '\n', '\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '        return a < b ? a : b;\n', '\n', '    }\n', '\n', '\n', '\n', '    function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '\n', '        uint256 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract privlocatum is ERC20, Owned {\n', '\n', '    //Applies SafeMath library to uint256 operations\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '\n', '    //Public variables\n', '\n', '    string public name;\n', '\n', '    string public symbol;\n', '\n', '    uint256 public decimals;\n', '\n', '    uint256 public totalSupply;\n', '\n', '\n', '\n', '    //Variables\n', '\n', '    uint256 multiplier;\n', '\n', '\n', '\n', '    //Creates arrays for balances\n', '\n', '    mapping (address => uint256) balance;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '\n', '    //Creates modifier to prevent short address attack\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '\n', '        if(msg.data.length < size + 4) revert();\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Constructor\n', '\n', '    function privlocatum(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier) {\n', '\n', '        name = tokenName;\n', '\n', '        symbol = tokenSymbol;\n', '\n', '        decimals = decimalUnits;\n', '\n', '        multiplier = decimalMultiplier;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Provides the remaining balance of approved tokens from function approve\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\n', '      return allowed[_owner][_spender];\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows for a certain amount of tokens to be spent on behalf of the account owner\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Returns the account balance\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 remainingBalance) {\n', '\n', '        return balance[_owner];\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows contract owner to mint new tokens, prevents numerical overflow\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {\n', '\n', '        require(mintedAmount > 0);\n', '\n', '        uint256 addTokens = mintedAmount;\n', '\n', '        balance[target] += addTokens;\n', '\n', '        totalSupply += addTokens;\n', '\n', '        Transfer(0, target, addTokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', "    //Sends tokens from sender's account\n", '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '\n', '        if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {\n', '\n', '            balance[msg.sender] -= _value;\n', '\n', '            balance[_to] += _value;\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '\n', '            return true;\n', '\n', '        } else {\n', '\n', '            return false;\n', '\n', '        }\n', '\n', '    }\n', '\n', '\n', '    //Transfers tokens from an approved account\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {\n', '\n', '        if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {\n', '\n', '            balance[_to] += _value;\n', '\n', '            balance[_from] -= _value;\n', '\n', '            allowed[_from][msg.sender] -= _value;\n', '\n', '            Transfer(_from, _to, _value);\n', '\n', '            return true;\n', '\n', '        } else {\n', '\n', '            return false;\n', '\n', '        }\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract privlocatumICO is Owned, privlocatum {\n', '\n', '    //Applies SafeMath library to uint256 operations\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '\n', '    //Public Variables\n', '\n', '    address public multiSigWallet;\n', '\n', '    uint256 public amountRaised;\n', '\n', '    uint256 public startTime;\n', '\n', '    uint256 public stopTime;\n', '\n', '    uint256 public hardcap;\n', '\n', '    uint256 public price;\n', '\n', '\n', '\n', '    //Variables\n', '\n', '    bool crowdsaleClosed = true;\n', '\n', '    string tokenName = "Privlocatum";\n', '\n', '    string tokenSymbol = "PLT";\n', '\n', '    uint256 multiplier = 100000000;\n', '\n', '    uint8 decimalUnits = 8;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '    //Initializes the token\n', '\n', '    function privlocatumICO()\n', '\n', '        privlocatum(tokenName, tokenSymbol, decimalUnits, multiplier) {\n', '\n', '            multiSigWallet = msg.sender;\n', '\n', '            hardcap = 70000000;\n', '\n', '            hardcap = hardcap.mul(multiplier);\n', '\n', '    }\n', '\n', '\n', '\n', '    //Fallback function creates tokens and sends to investor when crowdsale is open\n', '\n', '    function () payable {\n', '\n', '        require(!crowdsaleClosed\n', '\n', '            && (now < stopTime)\n', '\n', '            && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap));\n', '\n', '        address recipient = msg.sender;\n', '\n', '        amountRaised = amountRaised.add(msg.value.div(1 ether));\n', '\n', '        uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);\n', '\n', '        totalSupply = totalSupply.add(tokens);\n', '\n', '        balance[recipient] = balance[recipient].add(tokens);\n', '\n', '        require(multiSigWallet.send(msg.value));\n', '\n', '        Transfer(0, recipient, tokens);\n', '\n', '    }\n', '\n', '\n', '\n', '    //Returns the current price of the token for the crowdsale\n', '\n', '    function getPrice() returns (uint256 result) {\n', '\n', '        return price;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Returns time remaining on crowdsale\n', '\n', '    function getRemainingTime() constant returns (uint256) {\n', '\n', '        return stopTime;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Set the sale hardcap amount\n', '\n', '    function setHardCapValue(uint256 newHardcap) onlyOwner returns (bool success) {\n', '\n', '        hardcap = newHardcap.mul(multiplier);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Sets the multisig wallet for a crowdsale\n', '\n', '    function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {\n', '\n', '        multiSigWallet = wallet;\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Sets the token price\n', '\n', '    function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {\n', '\n', '        require(newPriceperEther > 0);\n', '\n', '        price = newPriceperEther;\n', '\n', '        return price;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows owner to start the crowdsale from the time of execution until a specified stopTime\n', '\n', '    function startSale(uint256 saleStart, uint256 saleStop, uint256 salePrice, address setBeneficiary) onlyOwner returns (bool success) {\n', '\n', '        require(saleStop > now);\n', '\n', '        startTime = saleStart;\n', '\n', '        stopTime = saleStop;\n', '\n', '        crowdsaleClosed = false;\n', '\n', '        setPrice(salePrice);\n', '\n', '        setMultiSigWallet(setBeneficiary);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    //Allows owner to stop the crowdsale immediately\n', '\n', '    function stopSale() onlyOwner returns (bool success) {\n', '\n', '        stopTime = now;\n', '\n', '        crowdsaleClosed = true;\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '}']
