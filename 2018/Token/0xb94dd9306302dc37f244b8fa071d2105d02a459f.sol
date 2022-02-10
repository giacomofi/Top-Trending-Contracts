['pragma solidity ^0.4.15;\n', '\n', '/* taking ideas from FirstBlood token */\n', 'contract SafeMath {\n', '\n', '    /* function assert(bool assertion) internal { */\n', '    /*   if (!assertion) { */\n', '    /*     throw; */\n', '    /*   } */\n', '    /* }      // assert no longer needed once solidity is on 0.4.10 */\n', '\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x + y;\n', '      assert((z >= x) && (z >= y));\n', '      return z;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '}\n', '\n', 'contract owned {\n', '    address public owner;\n', '    address[] public allowedTransferDuringICO;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '\n', '    function isAllowedTransferDuringICO() public constant returns (bool){\n', '        for(uint i = 0; i < allowedTransferDuringICO.length; i++) {\n', '            if (allowedTransferDuringICO[i] == msg.sender) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '}\n', '\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract Token is owned {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    \n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is SafeMath, Token {\n', '\n', '    uint public lockBlock;\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(block.number >= lockBlock || isAllowedTransferDuringICO());\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require(block.number >= lockBlock || isAllowedTransferDuringICO());\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            balances[_from] = safeSub(balances[_from], _value);\n', '            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        assert((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract EICToken is StandardToken {\n', '\n', '    // metadata\n', '    string constant public name = "Entertainment Industry Coin";\n', '    string constant public symbol = "EIC";\n', '    uint256 constant public decimals = 18;\n', '\n', '    function EICToken(\n', '        uint _lockBlockPeriod)\n', '        public\n', '    {\n', '        allowedTransferDuringICO.push(owner);\n', '        totalSupply = 3125000000 * (10 ** decimals);\n', '        balances[owner] = totalSupply;\n', '        lockBlock = block.number + _lockBlockPeriod;\n', '    }\n', '\n', '    function distribute(address[] addr, uint256[] token) public onlyOwner {\n', '        // only owner can call\n', '        require(addr.length == token.length);\n', '        allowedTransferDuringICO.push(addr[0]);\n', '        allowedTransferDuringICO.push(addr[1]);\n', '        for (uint i = 0; i < addr.length; i++) {\n', '            transfer(addr[i], token[i] * (10 ** decimals));\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract CrowdSales {\n', '    address owner;\n', '\n', '    EICToken public token;\n', '\n', '    uint public tokenPrice;\n', '\n', '    struct Beneficiary {\n', '        address addr;\n', '        uint256 ratio;\n', '    }\n', '\n', '    Beneficiary[] public beneficiaries;\n', '\n', '    event Bid(address indexed bider, uint256 getToken);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function CrowdSales(address _tokenAddress) public {\n', '        owner = msg.sender;\n', '        beneficiaries.push(Beneficiary(0xA5A6b44312a2fc363D78A5af22a561E9BD3151be, 10));\n', '        beneficiaries.push(Beneficiary(0x8Ec21f2f285545BEc0208876FAd153e0DEE581Ba, 10));\n', '        beneficiaries.push(Beneficiary(0x81D98B74Be1C612047fEcED3c316357c48daDc83, 5));\n', '        beneficiaries.push(Beneficiary(0x882Efb2c4F3B572e3A8B33eb668eeEdF1e88e7f0, 10));\n', '        beneficiaries.push(Beneficiary(0xe63286CCaB12E10B9AB01bd191F83d2262bde078, 15));\n', '        beneficiaries.push(Beneficiary(0x8a2454C1c79C23F6c801B0c2665dfB9Eab0539b1, 285));\n', '        beneficiaries.push(Beneficiary(0x4583408F92427C52D1E45500Ab402107972b2CA6, 665));\n', '        token = EICToken(_tokenAddress);\n', '        tokenPrice = 15000;\n', '    }\n', '\n', '    function () public payable {\n', '    \tbid();\n', '    }\n', '\n', '    function bid()\n', '    \tpublic\n', '    \tpayable\n', '    {\n', '    \trequire(block.number <= token.lockBlock());\n', '        require(this.balance <= 62500 * ( 10 ** 18 ));\n', '    \trequire(token.balanceOf(msg.sender) + (msg.value * tokenPrice) >= (5 * (10 ** 18)) * tokenPrice);\n', '    \trequire(token.balanceOf(msg.sender) + (msg.value * tokenPrice) <= (200 * (10 ** 18)) * tokenPrice);\n', '        token.transfer(msg.sender, msg.value * tokenPrice);\n', '        Bid(msg.sender, msg.value * tokenPrice);\n', '    }\n', '\n', '    function finalize() public onlyOwner {\n', '        require(block.number > token.lockBlock() || this.balance == 62500 * ( 10 ** 18 ));\n', '        uint receiveWei = this.balance;\n', '        for (uint i = 0; i < beneficiaries.length; i++) {\n', '            Beneficiary storage beneficiary = beneficiaries[i];\n', '            uint256 value = (receiveWei * beneficiary.ratio)/(1000);\n', '            beneficiary.addr.transfer(value);\n', '        }\n', '        if (token.balanceOf(this) > 0) {\n', '            uint256 remainingToken = token.balanceOf(this);\n', '            address owner30 = 0x8a2454C1c79C23F6c801B0c2665dfB9Eab0539b1;\n', '            address owner70 = 0x4583408F92427C52D1E45500Ab402107972b2CA6;\n', '\n', '            token.transfer(owner30, (remainingToken * 30)/(100));\n', '            token.transfer(owner70, (remainingToken * 70)/(100));\n', '        }\n', '        owner.transfer(this.balance);\n', '    }\n', '}']