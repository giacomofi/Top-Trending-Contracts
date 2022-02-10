['pragma solidity ^0.4.11;\n', '\n', 'contract SafeMath {\n', '\n', '    function safeMul(uint256 a, uint256 b) internal returns (uint256 ) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal returns (uint256 ) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal returns (uint256 ) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal returns (uint256 ) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '            throw;\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @dev Transfers sender&#39;s tokens to a given address. Returns success.\n', '    /// @param _to Address of token receiver.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from Address from where tokens are withdrawn.\n', '    /// @param _to Address to where tokens are sent.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            balances[_from] = safeSub(balances[_from], _value);\n', '            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success.\n', '    /// @param _spender Address of allowed account.\n', '    /// @param _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Returns number of allowed tokens for given address.\n', '    /// @param _owner Address of token owner.\n', '    /// @param _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract MultiOwnable {\n', '\n', '    mapping (address => bool) ownerMap;\n', '    address[] public owners;\n', '\n', '    event OwnerAdded(address indexed _newOwner);\n', '    event OwnerRemoved(address indexed _oldOwner);\n', '\n', '    modifier onlyOwner() {\n', '        if (!isOwner(msg.sender)) throw;\n', '        _;\n', '    }\n', '\n', '    function MultiOwnable() {\n', '        // Add default owner\n', '        address owner = msg.sender;\n', '        ownerMap[owner] = true;\n', '        owners.push(owner);\n', '    }\n', '\n', '    function ownerCount() constant returns (uint256) {\n', '        return owners.length;\n', '    }\n', '\n', '    function isOwner(address owner) constant returns (bool) {\n', '        return ownerMap[owner];\n', '    }\n', '\n', '    function addOwner(address owner) onlyOwner returns (bool) {\n', '        if (!isOwner(owner) && owner != 0) {\n', '            ownerMap[owner] = true;\n', '            owners.push(owner);\n', '\n', '            OwnerAdded(owner);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    function removeOwner(address owner) onlyOwner returns (bool) {\n', '        if (isOwner(owner)) {\n', '            ownerMap[owner] = false;\n', '            for (uint i = 0; i < owners.length - 1; i++) {\n', '                if (owners[i] == owner) {\n', '                    owners[i] = owners[owners.length - 1];\n', '                    break;\n', '                }\n', '            }\n', '            owners.length -= 1;\n', '\n', '            OwnerRemoved(owner);\n', '            return true;\n', '        } else return false;\n', '    }\n', '}\n', '\n', 'contract TokenSpender {\n', '    function receiveApproval(address _from, uint256 _value);\n', '}\n', '\n', 'contract BsToken is StandardToken, MultiOwnable {\n', '\n', '    bool public locked;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals = 18;\n', '    string public version = &#39;v0.1&#39;;\n', '\n', '    address public creator;\n', '    address public seller;\n', '    uint256 public tokensSold;\n', '    uint256 public totalSales;\n', '\n', '    event Sell(address indexed _seller, address indexed _buyer, uint256 _value);\n', '    event SellerChanged(address indexed _oldSeller, address indexed _newSeller);\n', '\n', '    modifier onlyUnlocked() {\n', '        if (!isOwner(msg.sender) && locked) throw;\n', '        _;\n', '    }\n', '\n', '    function BsToken(string _name, string _symbol, uint256 _totalSupplyNoDecimals, address _seller) MultiOwnable() {\n', '\n', '        // Lock the transfer function during the presale/crowdsale to prevent speculations.\n', '        locked = true;\n', '\n', '        creator = msg.sender;\n', '        seller = _seller;\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        totalSupply = _totalSupplyNoDecimals * 1e18;\n', '\n', '        balances[seller] = totalSupply;\n', '        Transfer(0x0, seller, totalSupply);\n', '    }\n', '\n', '    function changeSeller(address newSeller) onlyOwner returns (bool) {\n', '        if (newSeller == 0x0 || seller == newSeller) throw;\n', '\n', '        address oldSeller = seller;\n', '\n', '        uint256 unsoldTokens = balances[oldSeller];\n', '        balances[oldSeller] = 0;\n', '        balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);\n', '        Transfer(oldSeller, newSeller, unsoldTokens);\n', '\n', '        seller = newSeller;\n', '        SellerChanged(oldSeller, newSeller);\n', '        return true;\n', '    }\n', '\n', '    function sellNoDecimals(address _to, uint256 _value) returns (bool) {\n', '        return sell(_to, _value * 1e18);\n', '    }\n', '\n', '    function sell(address _to, uint256 _value) onlyOwner returns (bool) {\n', '        if (balances[seller] >= _value && _value > 0) {\n', '            balances[seller] = safeSub(balances[seller], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            Transfer(seller, _to, _value);\n', '\n', '            tokensSold = safeAdd(tokensSold, _value);\n', '            totalSales = safeAdd(totalSales, 1);\n', '            Sell(seller, _to, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function lock() onlyOwner {\n', '        locked = true;\n', '    }\n', '\n', '    function unlock() onlyOwner {\n', '        locked = false;\n', '    }\n', '\n', '    function burn(uint256 _value) returns (bool) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value) ;\n', '            totalSupply = safeSub(totalSupply, _value);\n', '            Transfer(msg.sender, 0x0, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value) {\n', '        TokenSpender spender = TokenSpender(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value);\n', '        }\n', '    }\n', '}\n', '\n', 'contract BsToken_SNOV is BsToken {\n', '\n', '    function BsToken_SNOV()\n', '        BsToken(\n', '            &#39;Snovio&#39;,\n', '            &#39;SNOV&#39;,\n', '            2500000000,\n', '            0xDaE3f1D824127754Aca9Eb5E5bFBAC22d8A04A52\n', '        ) { }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract SafeMath {\n', '\n', '    function safeMul(uint256 a, uint256 b) internal returns (uint256 ) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal returns (uint256 ) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal returns (uint256 ) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal returns (uint256 ) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '            throw;\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', "    /// @dev Transfers sender's tokens to a given address. Returns success.\n", '    /// @param _to Address of token receiver.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from Address from where tokens are withdrawn.\n', '    /// @param _to Address to where tokens are sent.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            balances[_from] = safeSub(balances[_from], _value);\n', '            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success.\n', '    /// @param _spender Address of allowed account.\n', '    /// @param _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Returns number of allowed tokens for given address.\n', '    /// @param _owner Address of token owner.\n', '    /// @param _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract MultiOwnable {\n', '\n', '    mapping (address => bool) ownerMap;\n', '    address[] public owners;\n', '\n', '    event OwnerAdded(address indexed _newOwner);\n', '    event OwnerRemoved(address indexed _oldOwner);\n', '\n', '    modifier onlyOwner() {\n', '        if (!isOwner(msg.sender)) throw;\n', '        _;\n', '    }\n', '\n', '    function MultiOwnable() {\n', '        // Add default owner\n', '        address owner = msg.sender;\n', '        ownerMap[owner] = true;\n', '        owners.push(owner);\n', '    }\n', '\n', '    function ownerCount() constant returns (uint256) {\n', '        return owners.length;\n', '    }\n', '\n', '    function isOwner(address owner) constant returns (bool) {\n', '        return ownerMap[owner];\n', '    }\n', '\n', '    function addOwner(address owner) onlyOwner returns (bool) {\n', '        if (!isOwner(owner) && owner != 0) {\n', '            ownerMap[owner] = true;\n', '            owners.push(owner);\n', '\n', '            OwnerAdded(owner);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    function removeOwner(address owner) onlyOwner returns (bool) {\n', '        if (isOwner(owner)) {\n', '            ownerMap[owner] = false;\n', '            for (uint i = 0; i < owners.length - 1; i++) {\n', '                if (owners[i] == owner) {\n', '                    owners[i] = owners[owners.length - 1];\n', '                    break;\n', '                }\n', '            }\n', '            owners.length -= 1;\n', '\n', '            OwnerRemoved(owner);\n', '            return true;\n', '        } else return false;\n', '    }\n', '}\n', '\n', 'contract TokenSpender {\n', '    function receiveApproval(address _from, uint256 _value);\n', '}\n', '\n', 'contract BsToken is StandardToken, MultiOwnable {\n', '\n', '    bool public locked;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals = 18;\n', "    string public version = 'v0.1';\n", '\n', '    address public creator;\n', '    address public seller;\n', '    uint256 public tokensSold;\n', '    uint256 public totalSales;\n', '\n', '    event Sell(address indexed _seller, address indexed _buyer, uint256 _value);\n', '    event SellerChanged(address indexed _oldSeller, address indexed _newSeller);\n', '\n', '    modifier onlyUnlocked() {\n', '        if (!isOwner(msg.sender) && locked) throw;\n', '        _;\n', '    }\n', '\n', '    function BsToken(string _name, string _symbol, uint256 _totalSupplyNoDecimals, address _seller) MultiOwnable() {\n', '\n', '        // Lock the transfer function during the presale/crowdsale to prevent speculations.\n', '        locked = true;\n', '\n', '        creator = msg.sender;\n', '        seller = _seller;\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        totalSupply = _totalSupplyNoDecimals * 1e18;\n', '\n', '        balances[seller] = totalSupply;\n', '        Transfer(0x0, seller, totalSupply);\n', '    }\n', '\n', '    function changeSeller(address newSeller) onlyOwner returns (bool) {\n', '        if (newSeller == 0x0 || seller == newSeller) throw;\n', '\n', '        address oldSeller = seller;\n', '\n', '        uint256 unsoldTokens = balances[oldSeller];\n', '        balances[oldSeller] = 0;\n', '        balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);\n', '        Transfer(oldSeller, newSeller, unsoldTokens);\n', '\n', '        seller = newSeller;\n', '        SellerChanged(oldSeller, newSeller);\n', '        return true;\n', '    }\n', '\n', '    function sellNoDecimals(address _to, uint256 _value) returns (bool) {\n', '        return sell(_to, _value * 1e18);\n', '    }\n', '\n', '    function sell(address _to, uint256 _value) onlyOwner returns (bool) {\n', '        if (balances[seller] >= _value && _value > 0) {\n', '            balances[seller] = safeSub(balances[seller], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            Transfer(seller, _to, _value);\n', '\n', '            tokensSold = safeAdd(tokensSold, _value);\n', '            totalSales = safeAdd(totalSales, 1);\n', '            Sell(seller, _to, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function lock() onlyOwner {\n', '        locked = true;\n', '    }\n', '\n', '    function unlock() onlyOwner {\n', '        locked = false;\n', '    }\n', '\n', '    function burn(uint256 _value) returns (bool) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value) ;\n', '            totalSupply = safeSub(totalSupply, _value);\n', '            Transfer(msg.sender, 0x0, _value);\n', '            return true;\n', '        } else return false;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value) {\n', '        TokenSpender spender = TokenSpender(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value);\n', '        }\n', '    }\n', '}\n', '\n', 'contract BsToken_SNOV is BsToken {\n', '\n', '    function BsToken_SNOV()\n', '        BsToken(\n', "            'Snovio',\n", "            'SNOV',\n", '            2500000000,\n', '            0xDaE3f1D824127754Aca9Eb5E5bFBAC22d8A04A52\n', '        ) { }\n', '}']