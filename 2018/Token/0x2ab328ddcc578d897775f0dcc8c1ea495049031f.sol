['pragma solidity ^0.4.18;\n', '\n', 'contract SafeMath {\n', '  function mulSafe(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '       return 0;\n', '     }\n', '     uint256 c = a * b;\n', '     assert(c / a == b);\n', '     return c;\n', '   }\n', '\n', '  function divSafe(uint256 a, uint256 b) internal pure returns (uint256) {\n', '     uint256 c = a / b;\n', '     return c;\n', '  }\n', '\n', '  function subSafe(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '     return a - b;\n', '   }\n', '\n', '  function addSafe(uint256 a, uint256 b) internal pure returns (uint256) {\n', '     uint256 c = a + b;\n', '    assert(c >= a);\n', '     return c;\n', '   }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    function Constructor() public { owner = msg.sender; }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '   uint256 public totalSupply;\n', '   function balanceOf(address who) public view returns (uint256);\n', '   function transfer(address to, uint256 value) public returns (bool);\n', '   event Transfer(address indexed from, address indexed to, uint256 value);\n', '   function allowance(address owner, address spender) public view returns (uint256);\n', '   function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '   function approve(address spender, uint256 value) public returns (bool);\n', '   event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ERC223 {\n', '    function transfer(address to, uint value, bytes data) public;\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', 'contract ERC223ReceivingContract { \n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract StandardToken is ERC20, ERC223, SafeMath, Owned {\n', '  event ReleaseSupply(address indexed receiver, uint256 value, uint256 releaseTime);\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    balances[msg.sender] = subSafe(balances[msg.sender], _value);\n', '    balances[_to] = addSafe(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '   }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = subSafe(balances[_from], _value);\n', '     balances[_to] = addSafe(balances[_to], _value);\n', '     allowed[_from][msg.sender] = subSafe(allowed[_from][msg.sender], _value);\n', '    Transfer(_from, _to, _value);\n', '     return true;\n', '   }\n', '\n', '   function approve(address _spender, uint256 _value) public returns (bool) {\n', '     allowed[msg.sender][_spender] = _value;\n', '     Approval(msg.sender, _spender, _value);\n', '     return true;\n', '   }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '     return allowed[_owner][_spender];\n', '   }\n', '\n', '   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '     allowed[msg.sender][_spender] = addSafe(allowed[msg.sender][_spender], _addedValue);\n', '     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '     return true;\n', '   }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '     uint oldValue = allowed[msg.sender][_spender];\n', '     if (_subtractedValue > oldValue) {\n', '       allowed[msg.sender][_spender] = 0;\n', '     } else {\n', '       allowed[msg.sender][_spender] = subSafe(oldValue, _subtractedValue);\n', '    }\n', '     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '     return true;\n', '   }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public {\n', '        require(_value > 0 );\n', '        if(isContract(_to)) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        balances[msg.sender] = subSafe(balances[msg.sender], _value);\n', '        balances[_to] = addSafe(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '      }\n', '      return (length>0);\n', '    }\n', '\n', '}\n', '\n', 'contract ToxbtcToken is StandardToken {\n', '  string public name = &#39;Toxbtc Token&#39;;\n', '  string public symbol = &#39;TOX&#39;;\n', '  uint public decimals = 18;\n', '\n', '  uint256 createTime                = 1528214400;  //20180606 00:00:00\n', '  uint256 bonusEnds                 = 1529510400;  //20180621 00:00:00\n', '  uint256 endDate                   = 1530374400;  //20180701 00:00:00\n', '\n', '  uint256 firstAnnual               = 1559750400;  //20190606 00:00:00\n', '  uint256 secondAnnual              = 1591372800;  //20200606 00:00:00\n', '  uint256 thirdAnnual               = 1622908800;  //20210606 00:00:00\n', '\n', '  uint256 firstAnnualReleasedAmount =  300000000;\n', '  uint256 secondAnnualReleasedAmount=  300000000;\n', '  uint256 thirdAnnualReleasedAmount =  300000000;\n', '\n', '\n', '  function ToxbtcToken() public {\n', '    totalSupply   = 2000000000 * 10 ** uint256(decimals); \n', '    balances[msg.sender] = 1100000000 * 10 ** uint256(decimals);\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function () public payable {\n', '      require(now >= createTime && now <= endDate);\n', '      uint tokens;\n', '      if (now <= bonusEnds) {\n', '          tokens = msg.value * 24800;\n', '      } else {\n', '          tokens = msg.value * 20000;\n', '      }\n', '      require(tokens <= balances[owner]);\n', '      balances[msg.sender] = addSafe(balances[msg.sender], tokens);\n', '      balances[owner] = subSafe(balances[owner], tokens);\n', '      Transfer(address(0), msg.sender, tokens);\n', '      owner.transfer(msg.value);\n', '  }\n', '\n', '  function releaseSupply() public onlyOwner returns(uint256 _actualRelease) {\n', '    uint256 releaseAmount = getReleaseAmount();\n', '    require(releaseAmount > 0);\n', '    balances[owner] = addSafe(balances[owner], releaseAmount * 10 ** uint256(decimals));\n', '    totalSupply = addSafe(totalSupply, releaseAmount * 10 ** uint256(decimals));\n', '    Transfer(address(0), msg.sender, releaseAmount * 10 ** uint256(decimals));\n', '    return releaseAmount;\n', '  }\n', '\n', '  function getReleaseAmount() internal returns(uint256 _actualRelease) {\n', '        uint256 _amountToRelease;\n', '        if (    now >= firstAnnual\n', '             && now < secondAnnual\n', '             && firstAnnualReleasedAmount > 0) {\n', '            _amountToRelease = firstAnnualReleasedAmount;\n', '            firstAnnualReleasedAmount = 0;\n', '        } else if (    now >= secondAnnual \n', '                    && now < thirdAnnual\n', '                    && secondAnnualReleasedAmount > 0) {\n', '            _amountToRelease = secondAnnualReleasedAmount;\n', '            secondAnnualReleasedAmount = 0;\n', '        } else if (    now >= thirdAnnual \n', '                    && thirdAnnualReleasedAmount > 0) {\n', '            _amountToRelease = thirdAnnualReleasedAmount;\n', '            thirdAnnualReleasedAmount = 0;\n', '        } else {\n', '            _amountToRelease = 0;\n', '        }\n', '        return _amountToRelease;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract SafeMath {\n', '  function mulSafe(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '       return 0;\n', '     }\n', '     uint256 c = a * b;\n', '     assert(c / a == b);\n', '     return c;\n', '   }\n', '\n', '  function divSafe(uint256 a, uint256 b) internal pure returns (uint256) {\n', '     uint256 c = a / b;\n', '     return c;\n', '  }\n', '\n', '  function subSafe(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '     return a - b;\n', '   }\n', '\n', '  function addSafe(uint256 a, uint256 b) internal pure returns (uint256) {\n', '     uint256 c = a + b;\n', '    assert(c >= a);\n', '     return c;\n', '   }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    function Constructor() public { owner = msg.sender; }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '   uint256 public totalSupply;\n', '   function balanceOf(address who) public view returns (uint256);\n', '   function transfer(address to, uint256 value) public returns (bool);\n', '   event Transfer(address indexed from, address indexed to, uint256 value);\n', '   function allowance(address owner, address spender) public view returns (uint256);\n', '   function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '   function approve(address spender, uint256 value) public returns (bool);\n', '   event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ERC223 {\n', '    function transfer(address to, uint value, bytes data) public;\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', 'contract ERC223ReceivingContract { \n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract StandardToken is ERC20, ERC223, SafeMath, Owned {\n', '  event ReleaseSupply(address indexed receiver, uint256 value, uint256 releaseTime);\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    balances[msg.sender] = subSafe(balances[msg.sender], _value);\n', '    balances[_to] = addSafe(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '   }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = subSafe(balances[_from], _value);\n', '     balances[_to] = addSafe(balances[_to], _value);\n', '     allowed[_from][msg.sender] = subSafe(allowed[_from][msg.sender], _value);\n', '    Transfer(_from, _to, _value);\n', '     return true;\n', '   }\n', '\n', '   function approve(address _spender, uint256 _value) public returns (bool) {\n', '     allowed[msg.sender][_spender] = _value;\n', '     Approval(msg.sender, _spender, _value);\n', '     return true;\n', '   }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '     return allowed[_owner][_spender];\n', '   }\n', '\n', '   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '     allowed[msg.sender][_spender] = addSafe(allowed[msg.sender][_spender], _addedValue);\n', '     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '     return true;\n', '   }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '     uint oldValue = allowed[msg.sender][_spender];\n', '     if (_subtractedValue > oldValue) {\n', '       allowed[msg.sender][_spender] = 0;\n', '     } else {\n', '       allowed[msg.sender][_spender] = subSafe(oldValue, _subtractedValue);\n', '    }\n', '     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '     return true;\n', '   }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public {\n', '        require(_value > 0 );\n', '        if(isContract(_to)) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        balances[msg.sender] = subSafe(balances[msg.sender], _value);\n', '        balances[_to] = addSafe(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '      }\n', '      return (length>0);\n', '    }\n', '\n', '}\n', '\n', 'contract ToxbtcToken is StandardToken {\n', "  string public name = 'Toxbtc Token';\n", "  string public symbol = 'TOX';\n", '  uint public decimals = 18;\n', '\n', '  uint256 createTime                = 1528214400;  //20180606 00:00:00\n', '  uint256 bonusEnds                 = 1529510400;  //20180621 00:00:00\n', '  uint256 endDate                   = 1530374400;  //20180701 00:00:00\n', '\n', '  uint256 firstAnnual               = 1559750400;  //20190606 00:00:00\n', '  uint256 secondAnnual              = 1591372800;  //20200606 00:00:00\n', '  uint256 thirdAnnual               = 1622908800;  //20210606 00:00:00\n', '\n', '  uint256 firstAnnualReleasedAmount =  300000000;\n', '  uint256 secondAnnualReleasedAmount=  300000000;\n', '  uint256 thirdAnnualReleasedAmount =  300000000;\n', '\n', '\n', '  function ToxbtcToken() public {\n', '    totalSupply   = 2000000000 * 10 ** uint256(decimals); \n', '    balances[msg.sender] = 1100000000 * 10 ** uint256(decimals);\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function () public payable {\n', '      require(now >= createTime && now <= endDate);\n', '      uint tokens;\n', '      if (now <= bonusEnds) {\n', '          tokens = msg.value * 24800;\n', '      } else {\n', '          tokens = msg.value * 20000;\n', '      }\n', '      require(tokens <= balances[owner]);\n', '      balances[msg.sender] = addSafe(balances[msg.sender], tokens);\n', '      balances[owner] = subSafe(balances[owner], tokens);\n', '      Transfer(address(0), msg.sender, tokens);\n', '      owner.transfer(msg.value);\n', '  }\n', '\n', '  function releaseSupply() public onlyOwner returns(uint256 _actualRelease) {\n', '    uint256 releaseAmount = getReleaseAmount();\n', '    require(releaseAmount > 0);\n', '    balances[owner] = addSafe(balances[owner], releaseAmount * 10 ** uint256(decimals));\n', '    totalSupply = addSafe(totalSupply, releaseAmount * 10 ** uint256(decimals));\n', '    Transfer(address(0), msg.sender, releaseAmount * 10 ** uint256(decimals));\n', '    return releaseAmount;\n', '  }\n', '\n', '  function getReleaseAmount() internal returns(uint256 _actualRelease) {\n', '        uint256 _amountToRelease;\n', '        if (    now >= firstAnnual\n', '             && now < secondAnnual\n', '             && firstAnnualReleasedAmount > 0) {\n', '            _amountToRelease = firstAnnualReleasedAmount;\n', '            firstAnnualReleasedAmount = 0;\n', '        } else if (    now >= secondAnnual \n', '                    && now < thirdAnnual\n', '                    && secondAnnualReleasedAmount > 0) {\n', '            _amountToRelease = secondAnnualReleasedAmount;\n', '            secondAnnualReleasedAmount = 0;\n', '        } else if (    now >= thirdAnnual \n', '                    && thirdAnnualReleasedAmount > 0) {\n', '            _amountToRelease = thirdAnnualReleasedAmount;\n', '            thirdAnnualReleasedAmount = 0;\n', '        } else {\n', '            _amountToRelease = 0;\n', '        }\n', '        return _amountToRelease;\n', '    }\n', '}']
