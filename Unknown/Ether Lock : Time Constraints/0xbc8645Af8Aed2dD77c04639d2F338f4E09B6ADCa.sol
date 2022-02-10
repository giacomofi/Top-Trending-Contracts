['pragma solidity ^0.4.11;\n', '\n', '\t//\tHUNT Crowdsale Token Contract \n', '\t//\tAqua Commerce LTD Company #194644 (Republic of Seychelles)\n', '\t//\tThe MIT Licence .\n', '\n', '\n', 'contract SafeMath {\n', '\t\n', '    function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert((z = x - y) <= x);\n', '    }\n', '\n', '    function add(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert((z = x + y) >= x);\n', '    }\n', '\t\n', '\tfunction div(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        z = x / y;\n', '    }\n', '\t\n', '\tfunction min(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        z = x <= y ? x : y;\n', '    }\n', '}\n', '\n', '\n', 'contract Owned {\n', '    \n', '\taddress public owner;\n', '    address public newOwner;\n', '\t\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        assert (msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', ' \n', '    function acceptOwnership() {\n', '        if (msg.sender == newOwner) {\n', '            OwnershipTransferred(owner, newOwner);\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '//\tERC20 interface\n', '//\tsee https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 {\n', '\t\n', '\tfunction totalSupply() constant returns (uint totalSupply);\n', '\tfunction balanceOf(address who) constant returns (uint);\n', '\tfunction allowance(address owner, address spender) constant returns (uint);\n', '\t\n', '\tfunction transfer(address to, uint value) returns (bool ok);\n', '\tfunction transferFrom(address from, address to, uint value) returns (bool ok);\n', '\tfunction approve(address spender, uint value) returns (bool ok);\n', '  \n', '\tevent Transfer(address indexed from, address indexed to, uint value);\n', '\tevent Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '\t\n', '\tuint256                                            _totalSupply;\n', '    mapping (address => uint256)                       _balances;\n', '    mapping (address => mapping (address => uint256))  _approvals;\n', '    \n', '    modifier onlyPayloadSize(uint numwords) {\n', '\t\tassert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '   }\n', '   \n', '    function totalSupply() constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address _who) constant returns (uint256) {\n', '        return _balances[_who];\n', '    }\n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return _approvals[_owner][_spender];\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) onlyPayloadSize(2) returns (bool success) {\n', '        assert(_balances[msg.sender] >= _value);\n', '        \n', '        _balances[msg.sender] = sub(_balances[msg.sender], _value);\n', '        _balances[_to] = add(_balances[_to], _value);\n', '        \n', '        Transfer(msg.sender, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3) returns (bool success) {\n', '        assert(_balances[_from] >= _value);\n', '        assert(_approvals[_from][msg.sender] >= _value);\n', '        \n', '        _approvals[_from][msg.sender] = sub(_approvals[_from][msg.sender], _value);\n', '        _balances[_from] = sub(_balances[_from], _value);\n', '        _balances[_to] = add(_balances[_to], _value);\n', '        \n', '        Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {\n', '        _approvals[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract HUNT is StandardToken, Owned {\n', '\n', '    // Token information\n', '\tstring public constant name = "HUNT";\n', '    string public constant symbol = "HT";\n', '    uint8 public constant decimals = 18;\n', '\t\n', '    // Initial contract data\n', '\tuint256 public capTokens;\n', '    uint256 public startDate;\n', '    uint256 public endDate;\n', '    uint public curs;\n', '\t\n', '\taddress addrcnt;\n', '\tuint256 public totalTokens;\n', '\tuint256 public totalEthers;\n', '\tmapping (address => uint256) _userBonus;\n', '\t\n', '    event BoughtTokens(address indexed buyer, uint256 ethers,uint256 newEtherBalance, uint256 tokens, uint _buyPrice);\n', '\tevent Collect(address indexed addrcnt,uint256 amount);\n', '\t\n', '    function HUNT(uint256 _start, uint256 _end, uint256 _capTokens, uint _curs, address _addrcnt) {\n', '        startDate\t= _start;\n', '\t\tendDate\t\t= _end;\n', '        capTokens   = _capTokens;\n', '        addrcnt  \t= _addrcnt;\n', '\t\tcurs\t\t= _curs;\n', '    }\n', '\n', '\tfunction time() internal constant returns (uint) {\n', '        return block.timestamp;\n', '    }\n', '\t\n', '    // Cost of one token\n', '    // Day  1-2  : 1 USD = 1 HUNT\n', '    // Days 3–5  : 1.2 USD = 1 HUNT\n', '    // Days 6–10 : 1.3 USD = 1 HUNT\n', '    // Days 11–15: 1.4 USD = 1 HUNT\n', '    // Days 16–22: 1.5 USD = 1 HUNT\n', '    \n', '    \n', '    function buyPrice() constant returns (uint256) {\n', '        return buyPriceAt(time());\n', '    }\n', '\n', '\tfunction buyPriceAt(uint256 at) constant returns (uint256) {\n', '        if (at < startDate) {\n', '            return 0;\n', '        } else if (at < (startDate + 2 days)) {\n', '            return div(curs,100);\n', '        } else if (at < (startDate + 5 days)) {\n', '            return div(curs,120);\n', '        } else if (at < (startDate + 10 days)) {\n', '            return div(curs,130);\n', '        } else if (at < (startDate + 15 days)) {\n', '            return div(curs,140);\n', '        } else if (at <= endDate) {\n', '            return div(curs,150);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    // Buy tokens from the contract\n', '    function () payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // Exchanges can buy on behalf of participant\n', '    function buyTokens(address participant) payable {\n', '        \n', '\t\t// No contributions before the start of the crowdsale\n', '        require(time() >= startDate);\n', '        \n', '\t\t// No contributions after the end of the crowdsale\n', '        require(time() <= endDate);\n', '        \n', '\t\t// No 0 contributions\n', '        require(msg.value > 0);\n', '\n', '        // Add ETH raised to total\n', '        totalEthers = add(totalEthers, msg.value);\n', '        \n', '\t\t// What is the HUNT to ETH rate\n', '        uint256 _buyPrice = buyPrice();\n', '\t\t\n', '        // Calculate #HUNT - this is safe as _buyPrice is known\n', '        // and msg.value is restricted to valid values\n', '        uint tokens = msg.value * _buyPrice;\n', '\n', '        // Check tokens > 0\n', '        require(tokens > 0);\n', '\n', '\t\tif ((time() >= (startDate + 15 days)) && (time() <= endDate)){\n', '\t\t\tuint leftTokens=sub(capTokens,add(totalTokens, tokens));\n', '\t\t\tleftTokens = (leftTokens>0)? leftTokens:0;\n', '\t\t\tuint bonusTokens = min(_userBonus[participant],min(tokens,leftTokens));\n', '\t\t\t\n', '\t\t\t// Check bonusTokens >= 0\n', '\t\t\trequire(bonusTokens >= 0);\n', '\t\t\t\n', '\t\t\ttokens = add(tokens,bonusTokens);\n', '        }\n', '\t\t\n', '\t\t// Cannot exceed capTokens\n', '\t\ttotalTokens = add(totalTokens, tokens);\n', '        require(totalTokens <= capTokens);\n', '\n', '\t\t// Compute tokens for foundation 38%\n', '        // Number of tokens restricted so maths is safe\n', '        uint ownerTokens = div(tokens,50)*19;\n', '\n', '\t\t// Add to total supply\n', '        _totalSupply = add(_totalSupply, tokens);\n', '\t\t_totalSupply = add(_totalSupply, ownerTokens);\n', '\t\t\n', '        // Add to balances\n', '        _balances[participant] = add(_balances[participant], tokens);\n', '\t\t_balances[owner] = add(_balances[owner], ownerTokens);\n', '\n', '\t\t// Add to user bonus\n', '\t\tif (time() < (startDate + 2 days)){\n', '\t\t\tuint bonus = div(tokens,2);\n', '\t\t\t_userBonus[participant] = add(_userBonus[participant], bonus);\n', '        }\n', '\t\t\n', '\t\t// Log events\n', '        BoughtTokens(participant, msg.value, totalEthers, tokens, _buyPrice);\n', '        Transfer(0x0, participant, tokens);\n', '\t\tTransfer(0x0, owner, ownerTokens);\n', '\n', '    }\n', '\n', '    // Transfer the balance from owner&#39;s account to another account, with a\n', '    // check that the crowdsale is finalised \n', '    function transfer(address _to, uint _amount) returns (bool success) {\n', '        // Cannot transfer before crowdsale ends + 7 days\n', '        require((time() > endDate + 7 days ));\n', '        // Standard transfer\n', '        return super.transfer(_to, _amount);\n', '    }\n', '\n', '    // Spender of tokens transfer an amount of tokens from the token owner&#39;s\n', '    // balance to another account, with a check that the crowdsale is\n', '    // finalised \n', '    function transferFrom(address _from, address _to, uint _amount) returns (bool success) {\n', '        // Cannot transfer before crowdsale ends + 7 days\n', '        require((time() > endDate + 7 days ));\n', '        // Standard transferFrom\n', '        return super.transferFrom(_from, _to, _amount);\n', '    }\n', '\n', '    function mint(uint256 _amount) onlyOwner {\n', '        require((time() > endDate + 7 days ));\n', '        require(_amount > 0);\n', '        _balances[owner] = add(_balances[owner], _amount);\n', '        _totalSupply = add(_totalSupply, _amount);\n', '        Transfer(0x0, owner, _amount);\n', '    }\n', '\n', '    function burn(uint256 _amount) onlyOwner {\n', '\t\trequire((time() > endDate + 7 days ));\n', '        require(_amount > 0);\n', '        _balances[owner] = sub(_balances[owner],_amount);\n', '        _totalSupply = sub(_totalSupply,_amount);\n', '\t\tTransfer(owner, 0x0 , _amount);\n', '    }\n', '    \n', '\tfunction setCurs(uint8 _curs) onlyOwner {\n', '        require(_curs > 0);\n', '        curs = _curs;\n', '    }\n', '\n', '  \t// Crowdsale owners can collect ETH any number of times\n', '    function collect() onlyOwner {\n', '\t\trequire(addrcnt.call.value(this.balance)(0));\n', '\t\tCollect(addrcnt,this.balance);\n', '\t}\n', '}']