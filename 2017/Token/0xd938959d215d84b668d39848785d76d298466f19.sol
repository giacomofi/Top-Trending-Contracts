['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '\tfunction smul(uint256 a, uint256 b) internal pure returns (uint256) {\t\t\n', '\t\tif(a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\trequire(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\t\n', '\tfunction sdiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a / b;\n', '\t\treturn c;\n', '\t}\n', '\t\n', '\tfunction ssub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\trequire( b <= a);\n', '\t\treturn a-b;\n', '\t}\n', '\n', '\tfunction sadd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\trequire(c >= a);\n', '\t\treturn c;\n', '\t}\n', '}\n', '\n', '/*\n', ' * Contract that is working with ERC223 tokens\n', ' */\n', ' contract ContractReceiver {\n', '\n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '\n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', '/*\n', ' * PetroleumToken is an ERC20 token with ERC223 Extensions\n', ' */\n', 'contract PetroleumToken {\n', '    \n', '    using SafeMath for uint256;\n', '\n', '    string public name \t\t\t= "Petroleum";\n', '    string public symbol \t\t= "OIL";\n', '    uint8 public decimals \t\t= 18;\n', '    uint256 public totalSupply  = 1000000 * 10**18;\n', '\tbool public tokenCreated \t= false;\n', '\tbool public mintingFinished = false;\n', '\n', '    address public owner;  \n', '    mapping(address => uint256) balances;\n', '\tmapping(address => mapping (address => uint256)) allowed;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '   function PetroleumToken() public {       \n', '        require(tokenCreated == false);\n', '        tokenCreated = true;\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '        require(balances[owner] > 0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\tmodifier canMint() {\n', '\t\trequire(!mintingFinished);\n', '\t\t_;\n', '\t}    \n', '   \n', '    function name() constant public returns (string _name) {\n', '        return name;\n', '    }\n', '    \n', '    function symbol() constant public returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    \n', '    function decimals() constant public returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '   \n', '    function totalSupply() constant public returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }   \n', '\n', '    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {\n', '       \n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {       \n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    function isContract(address _addr) constant private returns (bool) {\n', '        uint length;\n', '        assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) {\n', '            revert();\n', '        }\n', '        balances[msg.sender] = balanceOf(msg.sender).ssub(_value);\n', '        balances[_to] = balanceOf(_to).sadd(_value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) {\n', '            revert();\n', '        }\n', '        balances[msg.sender] = balanceOf(msg.sender).ssub(_value);\n', '        balances[_to] = balanceOf(_to).sadd(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '   \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '       \n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] = balanceOf(_to).ssub(_value);\n', '        balances[_from] = balanceOf(_from).sadd(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].ssub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '    \n', '    \n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].ssub(_value);\n', '        totalSupply = totalSupply.ssub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        allowed[_from][msg.sender].ssub(_value);\n', '        totalSupply.ssub(_value);\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '\tfunction mint(address _to, uint256 _value) onlyOwner canMint public returns (bool) {\n', '\t\ttotalSupply = totalSupply.sadd(_value);\n', '\t\tbalances[_to] = balances[_to].sadd(_value);\n', '\t\tMint(_to, _value);\n', '\t\tTransfer(address(0), _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction finishMinting() onlyOwner canMint public returns (bool) {\n', '\t\tmintingFinished = true;\n', '\t\tMintFinished();\n', '\t\treturn true;\n', '\t}\n', '}']