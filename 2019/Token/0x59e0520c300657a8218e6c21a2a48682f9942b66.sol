['pragma solidity ^0.4.24;\n', '//ERC20\n', 'contract ERC20Ownable {\n', '    address public owner;\n', '\n', '    function ERC20Ownable() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', 'contract ERC20 {\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20Token is ERC20,ERC20Ownable {\n', '    \n', '    mapping (address => uint256) balances;\n', '\tmapping (address => mapping (address => uint256)) allowed;\n', '\t\n', '    event Transfer(\n', '\t\taddress indexed _from,\n', '\t\taddress indexed _to,\n', '\t\tuint256 _value\n', '\t\t);\n', '\n', '\tevent Approval(\n', '\t\taddress indexed _owner,\n', '\t\taddress indexed _spender,\n', '\t\tuint256 _value\n', '\t\t);\n', '\t\t\n', '\t//Fix for short address attack against ERC20\n', '\tmodifier onlyPayloadSize(uint size) {\n', '\t\tassert(msg.data.length == size + 4);\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction balanceOf(address _owner) constant public returns (uint256) {\n', '\t\treturn balances[_owner];\n', '\t}\n', '\n', '\tfunction transfer(address _to, uint256 _value) onlyPayloadSize(2*32) public returns (bool){\n', '\t\trequire(balances[msg.sender] >= _value && _value > 0);\n', '\t    balances[msg.sender] -= _value;\n', '\t    balances[_to] += _value;\n', '\t    emit Transfer(msg.sender, _to, _value);\n', '\t    return true;\n', '    }\n', '\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public {\n', '\t\trequire(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '\tfunction approve(address _spender, uint256 _value) public {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\temit Approval(msg.sender, _spender, _value);\n', '\t}\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        //require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")), abi.encode(msg.sender, _value, this, _extraData)));\n', '        require(_spender.call(abi.encodeWithSelector(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")),msg.sender, _value, this, _extraData)));\n', '\n', '        return true;\n', '    }\n', '    \n', '\tfunction allowance(address _owner, address _spender) constant public returns (uint256) {\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '}\n', '\n', 'contract ERC20StandardToken is ERC20Token {\n', '\tuint256 public totalSupply;\n', '\tstring public name;\n', '\tuint256 public decimals;\n', '\tstring public symbol;\n', '\tbool public mintable;\n', '\n', '\n', '    function ERC20StandardToken(address _owner, string _name, string _symbol, uint256 _decimals, uint256 _totalSupply, bool _mintable) public {\n', '        require(_owner != address(0));\n', '        owner = _owner;\n', '\t\tdecimals = _decimals;\n', '\t\tsymbol = _symbol;\n', '\t\tname = _name;\n', '\t\tmintable = _mintable;\n', '        totalSupply = _totalSupply;\n', '        balances[_owner] = totalSupply;\n', '    }\n', '    \n', '    function mint(uint256 amount) onlyOwner public {\n', '\t\trequire(mintable);\n', '\t\trequire(amount >= 0);\n', '\t\tbalances[msg.sender] += amount;\n', '\t\ttotalSupply += amount;\n', '\t}\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool) {\n', '        require(balances[msg.sender] >= _value  && totalSupply >=_value && _value > 0);\n', '        balances[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Transfer(msg.sender, 0x0, _value);\n', '        return true;\n', '    }\n', '}\n', 'pragma solidity ^0.4.24;\n', '//ERC223\n', 'contract ERC223Ownable {\n', '    address public owner;\n', '\n', '    function ERC223Ownable() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', 'contract SafeMath {\n', '    uint256 constant public MAX_UINT256 =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {\n', '        if (x > MAX_UINT256 - y) revert();\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {\n', '        if (x < y) revert();\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {\n', '        if (y == 0) return 0;\n', '        if (x > MAX_UINT256 / y) revert();\n', '        return x * y;\n', '    }\n', '}\n', '\n', 'contract ERC223Token is ERC223, SafeMath {\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint256 public decimals;\n', '  uint256 public totalSupply;\n', '  bool public mintable;\n', '\n', '\n', '\n', '  function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '\n', '    if(isContract(_to)) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '        balances[_to] = safeAdd(balanceOf(_to), _value);\n', '        assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '\n', '\n', 'function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '\n', '  function transfer(address _to, uint _value) public returns (bool success) {\n', '\n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '  function isContract(address _addr) private view returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '      }\n', '      return (length>0);\n', '    }\n', '\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    emit Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    ContractReceiver receiver = ContractReceiver(_to);\n', '    receiver.tokenFallback(msg.sender, _value, _data);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    emit Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '}\n', '\n', '\n', '  function balanceOf(address _owner) public view returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract ERC223StandardToken is ERC223Token,ERC223Ownable {\n', '    \n', '    function ERC223StandardToken(address _owner, string _name, string _symbol, uint256 _decimals, uint256 _totalSupply, bool _mintable) public {\n', '        \n', '        require(_owner != address(0));\n', '        owner = _owner;\n', '\t\tdecimals = _decimals;\n', '\t\tsymbol = _symbol;\n', '\t\tname = _name;\n', '\t\tmintable = _mintable;\n', '        totalSupply = _totalSupply;\n', '        balances[_owner] = totalSupply;\n', '        emit Transfer(address(0), _owner, totalSupply);\n', '        emit Transfer(address(0), _owner, totalSupply, "");\n', '    }\n', '  \n', '    function mint(uint256 amount) onlyOwner public {\n', '\t\trequire(mintable);\n', '\t\trequire(amount >= 0);\n', '\t\tbalances[msg.sender] += amount;\n', '\t\ttotalSupply += amount;\n', '\t}\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool) {\n', '        require(balances[msg.sender] >= _value  && totalSupply >=_value && _value > 0);\n', '        balances[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Transfer(msg.sender, 0x0, _value);\n', '        return true;\n', '    }\n', '}\n', 'pragma solidity ^0.4.24;\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '//TokenMaker\n', 'contract TokenMaker is Ownable{\n', '    \n', '\tevent LogERC20TokenCreated(ERC20StandardToken token);\n', '\tevent LogERC223TokenCreated(ERC223StandardToken token);\n', '\n', '    address public receiverAddress;\n', '    uint public txFee = 0.1 ether;\n', '    uint public VIPFee = 1 ether;\n', '\n', '    /* VIP List */\n', '    mapping(address => bool) public vipList;\n', '\tuint public numContracts;\n', '\n', '    mapping(uint => address) public deployedContracts;\n', '\tmapping(address => address[]) public userDeployedContracts;\n', '\n', '    function () payable public{}\n', '\n', '    function getBalance(address _tokenAddress,uint _type) onlyOwner public {\n', '      address _receiverAddress = getReceiverAddress();\n', '      if(_tokenAddress == address(0)){\n', '          require(_receiverAddress.send(address(this).balance));\n', '          return;\n', '      }\n', '      if(_type == 0){\n', '          ERC20 erc20 = ERC20(_tokenAddress);\n', '          uint256 balance = erc20.balanceOf(this);\n', '          erc20.transfer(_receiverAddress, balance);\n', '      }else{\n', '          ERC223 erc223 = ERC223(_tokenAddress);\n', '          uint256 erc223_balance = erc223.balanceOf(this);\n', '          erc223.transfer(_receiverAddress, erc223_balance);\n', '      }\n', '    }\n', '    \n', '    //Register VIP\n', '    function registerVIP() payable public {\n', '      require(msg.value >= VIPFee);\n', '      address _receiverAddress = getReceiverAddress();\n', '      require(_receiverAddress.send(msg.value));\n', '      vipList[msg.sender] = true;\n', '    }\n', '\n', '\n', '    function addToVIPList(address[] _vipList) onlyOwner public {\n', '        for (uint i =0;i<_vipList.length;i++){\n', '            vipList[_vipList[i]] = true;\n', '        }\n', '    }\n', '\n', '\n', '    function removeFromVIPList(address[] _vipList) onlyOwner public {\n', '        for (uint i =0;i<_vipList.length;i++){\n', '        vipList[_vipList[i]] = false;\n', '        }\n', '   }\n', '\n', '    function isVIP(address _addr) public view returns (bool) {\n', '        return _addr == owner || vipList[_addr];\n', '    }\n', '\n', '\n', '    function setReceiverAddress(address _addr) onlyOwner public {\n', '        require(_addr != address(0));\n', '        receiverAddress = _addr;\n', '    }\n', '\n', '    function getReceiverAddress() public view returns  (address){\n', '        if(receiverAddress == address(0)){\n', '            return owner;\n', '        }\n', '\n', '        return receiverAddress;\n', '    }\n', '\n', '    function setVIPFee(uint _fee) onlyOwner public {\n', '        VIPFee = _fee;\n', '    }\n', '\n', '\n', '    function setTxFee(uint _fee) onlyOwner public {\n', '        txFee = _fee;\n', '    }\n', '\n', '    function getUserCreatedTokens(address _owner) public view returns  (address[]){\n', '        return userDeployedContracts[_owner];\n', '    }\n', '    \n', '    function create(string _name, string _symbol, uint256 _decimals, uint256 _totalSupply,  bool _mintable,uint256 _type) payable public returns(address a){\n', '         //check the tx fee\n', '        uint sendValue = msg.value;\n', '        address from = msg.sender;\n', '\t    bool vip = isVIP(from);\n', '        if(!vip){\n', '\t\t    require(sendValue >= txFee);\n', '        }\n', '        \n', '        address[] userAddresses = userDeployedContracts[from];\n', '\n', '        if(_type == 0){\n', '            ERC20StandardToken erc20Token = new ERC20StandardToken(from, _name, _symbol, _decimals, _totalSupply, _mintable);\n', '            userAddresses.push(erc20Token);\n', '            userDeployedContracts[from] = userAddresses;\n', '            deployedContracts[numContracts] = erc20Token;\n', '            numContracts++;\n', '            emit LogERC20TokenCreated(erc20Token);\n', '\t        return erc20Token;\n', '        }else{\n', '            ERC223StandardToken erc223Token = new ERC223StandardToken(from, _name, _symbol, _decimals, _totalSupply, _mintable);\n', '            userAddresses.push(erc223Token);\n', '            userDeployedContracts[from] = userAddresses;\n', '            deployedContracts[numContracts] = erc223Token;\n', '            numContracts++;\n', '            emit LogERC223TokenCreated(erc223Token);\n', '\t        return erc223Token;\n', '        }\n', '        \n', '     }\n', '    \n', '}']