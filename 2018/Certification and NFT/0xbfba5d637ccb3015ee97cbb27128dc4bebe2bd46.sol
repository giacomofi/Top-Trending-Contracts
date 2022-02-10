['pragma solidity ^0.4.23;\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '\n', '  // event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', 'contract ContractReceiver {\n', ' \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract KPRToken is ERC223 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '\n', '    \n', '    //public variables\n', '    string public constant symbol="KPR"; \n', '    string public constant name="KPR Coin"; \n', '    uint8 public constant decimals=18;\n', '\n', '    //1 ETH = 2,500 KPR\n', '    uint256 public  buyPrice = 2500;\n', '\n', '    //totalsupplyoftoken \n', '    uint public totalSupply = 100000000 * 10 ** uint(decimals);\n', '    \n', '    uint public buyabletoken = 70000000 * 10 ** uint(decimals);\n', '    //where the ETH goes \n', '    address public owner;\n', '    \n', '    //map the addresses\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    // 1514764800 : Jan 1 2018\n', '    uint256 phase1starttime = 1525132800; // Phase 1 Start Date May 1 2018\n', '    uint256 phase1endtime = 1527033540;  // Phase 1 End Date May 22 2018\n', '    uint256 phase2starttime = 1527811200;  // Phase 2 Start Date June 1 2018\n', '    uint256 phase2endtime = 1529711940; // Phase 2 End Date June 22 2018\n', '    \n', '    //create token function = check\n', '\n', '    function() payable{\n', '        require(msg.value > 0);\n', '        require(buyabletoken > 0);\n', '        require(now >= phase1starttime && now <= phase2endtime);\n', '        \n', '        if (now > phase1starttime && now < phase1endtime){\n', '            buyPrice = 3000;\n', '        } else if(now > phase2starttime && now < phase2endtime){\n', '            buyPrice = 2000;\n', '        }\n', '        \n', '        uint256 amount = msg.value.mul(buyPrice); \n', '        \n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        \n', '        balances[owner] = balances[owner].sub(amount);\n', '        \n', '        buyabletoken = buyabletoken.sub(amount);\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '    function KPRToken() {\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '    }\n', '    \n', '      event Burn(address indexed burner, uint256 value);\n', '\n', '      /**\n', '       * @dev Burns a specific amount of tokens.\n', '       * @param _value The amount of token to be burned.\n', '       */\n', '      function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '      }\n', '\n', '      function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '    \n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '      }\n', '\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        \n', '        return balances[_owner];\n', '        \n', '    }\n', '\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        \n', '        if (isContract(_to)) {\n', '            if (balanceOf(msg.sender) < _value)\n', '                revert();\n', '            balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '            balances[_to] = balanceOf(_to).add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '        \n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        \n', '        //standard function transfer similar to ERC20 transfer with no _data\n', '        //added due to backwards compatibility reasons\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '                //retrieve the size of the code on target address, this needs assembly\n', '                length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '\n', '    //function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value)\n', '            revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    //function that is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value)\n', '            revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    event Transfer(address indexed_from, address indexed_to, uint256 _value);\n', '    event Approval(address indexed_owner, address indexed_spender, uint256 _value);\n', '    \n', '    \n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '\n', '  // event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', 'contract ContractReceiver {\n', ' \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract KPRToken is ERC223 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '\n', '    \n', '    //public variables\n', '    string public constant symbol="KPR"; \n', '    string public constant name="KPR Coin"; \n', '    uint8 public constant decimals=18;\n', '\n', '    //1 ETH = 2,500 KPR\n', '    uint256 public  buyPrice = 2500;\n', '\n', '    //totalsupplyoftoken \n', '    uint public totalSupply = 100000000 * 10 ** uint(decimals);\n', '    \n', '    uint public buyabletoken = 70000000 * 10 ** uint(decimals);\n', '    //where the ETH goes \n', '    address public owner;\n', '    \n', '    //map the addresses\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    // 1514764800 : Jan 1 2018\n', '    uint256 phase1starttime = 1525132800; // Phase 1 Start Date May 1 2018\n', '    uint256 phase1endtime = 1527033540;  // Phase 1 End Date May 22 2018\n', '    uint256 phase2starttime = 1527811200;  // Phase 2 Start Date June 1 2018\n', '    uint256 phase2endtime = 1529711940; // Phase 2 End Date June 22 2018\n', '    \n', '    //create token function = check\n', '\n', '    function() payable{\n', '        require(msg.value > 0);\n', '        require(buyabletoken > 0);\n', '        require(now >= phase1starttime && now <= phase2endtime);\n', '        \n', '        if (now > phase1starttime && now < phase1endtime){\n', '            buyPrice = 3000;\n', '        } else if(now > phase2starttime && now < phase2endtime){\n', '            buyPrice = 2000;\n', '        }\n', '        \n', '        uint256 amount = msg.value.mul(buyPrice); \n', '        \n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        \n', '        balances[owner] = balances[owner].sub(amount);\n', '        \n', '        buyabletoken = buyabletoken.sub(amount);\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '    function KPRToken() {\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '    }\n', '    \n', '      event Burn(address indexed burner, uint256 value);\n', '\n', '      /**\n', '       * @dev Burns a specific amount of tokens.\n', '       * @param _value The amount of token to be burned.\n', '       */\n', '      function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '      }\n', '\n', '      function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '    \n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '      }\n', '\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        \n', '        return balances[_owner];\n', '        \n', '    }\n', '\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        \n', '        if (isContract(_to)) {\n', '            if (balanceOf(msg.sender) < _value)\n', '                revert();\n', '            balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '            balances[_to] = balanceOf(_to).add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '        \n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        \n', '        //standard function transfer similar to ERC20 transfer with no _data\n', '        //added due to backwards compatibility reasons\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '                //retrieve the size of the code on target address, this needs assembly\n', '                length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '\n', '    //function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value)\n', '            revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    //function that is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value)\n', '            revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    event Transfer(address indexed_from, address indexed_to, uint256 _value);\n', '    event Approval(address indexed_owner, address indexed_spender, uint256 _value);\n', '    \n', '    \n', '}']