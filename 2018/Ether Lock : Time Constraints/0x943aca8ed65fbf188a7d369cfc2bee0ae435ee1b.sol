['pragma solidity ^0.4.21;\n', '\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '  \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  \n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '   \n', '   \n', '   \n', '    return a / b;\n', '  }\n', '\n', '  \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  \n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  \n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  \n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  \n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  \n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  \n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  \n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '   \n', '   \n', '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', '\n', 'contract TokenOffering is StandardToken, Ownable, BurnableToken {\n', '  \n', '    bool public offeringEnabled;\n', '\n', '   \n', '    uint256 public currentTotalTokenOffering;\n', '\n', '   \n', '    uint256 public currentTokenOfferingRaised;\n', '\n', '   \n', '    uint256 public bonusRateOneEth;\n', '\n', '   \n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    bool public isBurnInClose = false;\n', '\n', '    bool public isOfferingStarted = false;\n', '\n', '    event OfferingOpens(uint256 startTime, uint256 endTime, uint256 totalTokenOffering, uint256 bonusRateOneEth);\n', '    event OfferingCloses(uint256 endTime, uint256 tokenOfferingRaised);\n', '\n', '    \n', '    function setBonusRate(uint256 _bonusRateOneEth) public onlyOwner {\n', '        bonusRateOneEth = _bonusRateOneEth;\n', '    }\n', '\n', '    \n', '   \n', '   \n', '   \n', '   \n', '\n', '    \n', '    function preValidatePurchase(uint256 _amount) internal {\n', '        require(_amount > 0);\n', '        require(isOfferingStarted);\n', '        require(offeringEnabled);\n', '        require(currentTokenOfferingRaised.add(_amount) <= currentTotalTokenOffering);\n', '        require(block.timestamp >= startTime && block.timestamp <= endTime);\n', '    }\n', '    \n', '    \n', '    function stopOffering() public onlyOwner {\n', '        offeringEnabled = false;\n', '    }\n', '    \n', '    \n', '    function resumeOffering() public onlyOwner {\n', '        offeringEnabled = true;\n', '    }\n', '\n', '    \n', '    function startOffering(\n', '        uint256 _tokenOffering, \n', '        uint256 _bonusRateOneEth, \n', '        uint256 _startTime, \n', '        uint256 _endTime,\n', '        bool _isBurnInClose\n', '    ) public onlyOwner returns (bool) {\n', '        require(_tokenOffering <= balances[owner]);\n', '        require(_startTime <= _endTime);\n', '        require(_startTime >= block.timestamp);\n', '\n', '       \n', '        require(!isOfferingStarted);\n', '\n', '        isOfferingStarted = true;\n', '\n', '       \n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '\n', '       \n', '        isBurnInClose = _isBurnInClose;\n', '\n', '       \n', '        currentTokenOfferingRaised = 0;\n', '        currentTotalTokenOffering = _tokenOffering;\n', '        offeringEnabled = true;\n', '        setBonusRate(_bonusRateOneEth);\n', '\n', '        emit OfferingOpens(startTime, endTime, currentTotalTokenOffering, bonusRateOneEth);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function updateStartTime(uint256 _startTime) public onlyOwner {\n', '        require(isOfferingStarted);\n', '        require(_startTime <= endTime);\n', '        require(_startTime >= block.timestamp);\n', '        startTime = _startTime;\n', '    }\n', '\n', '    \n', '    function updateEndTime(uint256 _endTime) public onlyOwner {\n', '        require(isOfferingStarted);\n', '        require(_endTime >= startTime);\n', '        endTime = _endTime;\n', '    }\n', '\n', '    \n', '    function updateBurnableStatus(bool _isBurnInClose) public onlyOwner {\n', '        require(isOfferingStarted);\n', '        isBurnInClose = _isBurnInClose;\n', '    }\n', '\n', '    \n', '    function endOffering() public onlyOwner {\n', '        if (isBurnInClose) {\n', '            burnRemainTokenOffering();\n', '        }\n', '        emit OfferingCloses(endTime, currentTokenOfferingRaised);\n', '        resetOfferingStatus();\n', '    }\n', '\n', '    \n', '    function burnRemainTokenOffering() internal {\n', '        if (currentTokenOfferingRaised < currentTotalTokenOffering) {\n', '            uint256 remainTokenOffering = currentTotalTokenOffering.sub(currentTokenOfferingRaised);\n', '            _burn(owner, remainTokenOffering);\n', '        }\n', '    }\n', '\n', '    \n', '    function resetOfferingStatus() internal {\n', '        isOfferingStarted = false;        \n', '        startTime = 0;\n', '        endTime = 0;\n', '        currentTotalTokenOffering = 0;\n', '        currentTokenOfferingRaised = 0;\n', '        bonusRateOneEth = 0;\n', '        offeringEnabled = false;\n', '        isBurnInClose = false;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract WithdrawTrack is StandardToken, Ownable {\n', '\n', '\tstruct TrackInfo {\n', '\t\taddress to;\n', '\t\tuint256 amountToken;\n', '\t\tstring withdrawId;\n', '\t}\n', '\n', '\tmapping(string => TrackInfo) withdrawTracks;\n', '\n', '\tfunction withdrawToken(address _to, uint256 _amountToken, string _withdrawId) public onlyOwner returns (bool) {\n', '\t\tbool result = transfer(_to, _amountToken);\n', '\t\tif (result) {\n', '\t\t\twithdrawTracks[_withdrawId] = TrackInfo(_to, _amountToken, _withdrawId);\n', '\t\t}\n', '\t\treturn result;\n', '\t}\n', '\n', '\tfunction withdrawTrackOf(string _withdrawId) public view returns (address to, uint256 amountToken) {\n', '\t\tTrackInfo track = withdrawTracks[_withdrawId];\n', '\t\treturn (track.to, track.amountToken);\n', '\t}\n', '\n', '}\n', '\n', '\n', 'contract ContractSpendToken is StandardToken, Ownable {\n', '  mapping (address => address) private contractToReceiver;\n', '\n', '  function addContract(address _contractAdd, address _to) external onlyOwner returns (bool) {\n', '    require(_contractAdd != address(0x0));\n', '    require(_to != address(0x0));\n', '\n', '    contractToReceiver[_contractAdd] = _to;\n', '    return true;\n', '  }\n', '\n', '  function removeContract(address _contractAdd) external onlyOwner returns (bool) {\n', '    contractToReceiver[_contractAdd] = address(0x0);\n', '    return true;\n', '  }\n', '\n', '  function contractSpend(address _from, uint256 _value) public returns (bool) {\n', '    address _to = contractToReceiver[msg.sender];\n', '    require(_to != address(0x0));\n', '    require(_value <= balances[_from]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function getContractReceiver(address _contractAdd) public view onlyOwner returns (address) {\n', '    return contractToReceiver[_contractAdd];\n', '  }\n', '}\n', '\n', 'contract ContractiumToken is TokenOffering, WithdrawTrack, ContractSpendToken {\n', '\n', '    string public constant name = "Contractium";\n', '    string public constant symbol = "CTU";\n', '    uint8 public constant decimals = 18;\n', '  \n', '    uint256 public constant INITIAL_SUPPLY = 3000000000 * (10 ** uint256(decimals));\n', '  \n', '    uint256 public unitsOneEthCanBuy = 15000;\n', '\n', '   \n', '    uint256 internal totalWeiRaised;\n', '\n', '    event BuyToken(address from, uint256 weiAmount, uint256 tokenAmount);\n', '\n', '    function ContractiumToken() public {\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        \n', '        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '    }\n', '\n', '    function() public payable {\n', '\n', '        require(msg.sender != owner);\n', '\n', '       \n', '        uint256 amount = msg.value.mul(unitsOneEthCanBuy);\n', '\n', '       \n', '        uint256 amountBonus = msg.value.mul(bonusRateOneEth);\n', '        \n', '       \n', '        amount = amount.add(amountBonus);\n', '\n', '       \n', '        preValidatePurchase(amount);\n', '        require(balances[owner] >= amount);\n', '        \n', '        totalWeiRaised = totalWeiRaised.add(msg.value);\n', '    \n', '       \n', '        currentTokenOfferingRaised = currentTokenOfferingRaised.add(amount); \n', '        \n', '        balances[owner] = balances[owner].sub(amount);\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '\n', '        emit Transfer(owner, msg.sender, amount);\n', '        emit BuyToken(msg.sender, msg.value, amount);\n', '       \n', '        owner.transfer(msg.value);  \n', '                              \n', '    }\n', '\n', '    function batchTransfer(address[] _receivers, uint256[] _amounts) public returns(bool) {\n', '        uint256 cnt = _receivers.length;\n', '        require(cnt > 0 && cnt <= 20);\n', '        require(cnt == _amounts.length);\n', '\n', '        cnt = (uint8)(cnt);\n', '\n', '        uint256 totalAmount = 0;\n', '        for (uint8 i = 0; i < cnt; i++) {\n', '            totalAmount = totalAmount.add(_amounts[i]);\n', '        }\n', '\n', '        require(totalAmount <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(totalAmount);\n', '        for (i = 0; i < cnt; i++) {\n', '            balances[_receivers[i]] = balances[_receivers[i]].add(_amounts[i]);            \n', '            emit Transfer(msg.sender, _receivers[i], _amounts[i]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '  \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  \n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '   \n', '   \n', '   \n', '    return a / b;\n', '  }\n', '\n', '  \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  \n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  \n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  \n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  \n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  \n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  \n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  \n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '   \n', '   \n', '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', '\n', 'contract TokenOffering is StandardToken, Ownable, BurnableToken {\n', '  \n', '    bool public offeringEnabled;\n', '\n', '   \n', '    uint256 public currentTotalTokenOffering;\n', '\n', '   \n', '    uint256 public currentTokenOfferingRaised;\n', '\n', '   \n', '    uint256 public bonusRateOneEth;\n', '\n', '   \n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    bool public isBurnInClose = false;\n', '\n', '    bool public isOfferingStarted = false;\n', '\n', '    event OfferingOpens(uint256 startTime, uint256 endTime, uint256 totalTokenOffering, uint256 bonusRateOneEth);\n', '    event OfferingCloses(uint256 endTime, uint256 tokenOfferingRaised);\n', '\n', '    \n', '    function setBonusRate(uint256 _bonusRateOneEth) public onlyOwner {\n', '        bonusRateOneEth = _bonusRateOneEth;\n', '    }\n', '\n', '    \n', '   \n', '   \n', '   \n', '   \n', '\n', '    \n', '    function preValidatePurchase(uint256 _amount) internal {\n', '        require(_amount > 0);\n', '        require(isOfferingStarted);\n', '        require(offeringEnabled);\n', '        require(currentTokenOfferingRaised.add(_amount) <= currentTotalTokenOffering);\n', '        require(block.timestamp >= startTime && block.timestamp <= endTime);\n', '    }\n', '    \n', '    \n', '    function stopOffering() public onlyOwner {\n', '        offeringEnabled = false;\n', '    }\n', '    \n', '    \n', '    function resumeOffering() public onlyOwner {\n', '        offeringEnabled = true;\n', '    }\n', '\n', '    \n', '    function startOffering(\n', '        uint256 _tokenOffering, \n', '        uint256 _bonusRateOneEth, \n', '        uint256 _startTime, \n', '        uint256 _endTime,\n', '        bool _isBurnInClose\n', '    ) public onlyOwner returns (bool) {\n', '        require(_tokenOffering <= balances[owner]);\n', '        require(_startTime <= _endTime);\n', '        require(_startTime >= block.timestamp);\n', '\n', '       \n', '        require(!isOfferingStarted);\n', '\n', '        isOfferingStarted = true;\n', '\n', '       \n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '\n', '       \n', '        isBurnInClose = _isBurnInClose;\n', '\n', '       \n', '        currentTokenOfferingRaised = 0;\n', '        currentTotalTokenOffering = _tokenOffering;\n', '        offeringEnabled = true;\n', '        setBonusRate(_bonusRateOneEth);\n', '\n', '        emit OfferingOpens(startTime, endTime, currentTotalTokenOffering, bonusRateOneEth);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function updateStartTime(uint256 _startTime) public onlyOwner {\n', '        require(isOfferingStarted);\n', '        require(_startTime <= endTime);\n', '        require(_startTime >= block.timestamp);\n', '        startTime = _startTime;\n', '    }\n', '\n', '    \n', '    function updateEndTime(uint256 _endTime) public onlyOwner {\n', '        require(isOfferingStarted);\n', '        require(_endTime >= startTime);\n', '        endTime = _endTime;\n', '    }\n', '\n', '    \n', '    function updateBurnableStatus(bool _isBurnInClose) public onlyOwner {\n', '        require(isOfferingStarted);\n', '        isBurnInClose = _isBurnInClose;\n', '    }\n', '\n', '    \n', '    function endOffering() public onlyOwner {\n', '        if (isBurnInClose) {\n', '            burnRemainTokenOffering();\n', '        }\n', '        emit OfferingCloses(endTime, currentTokenOfferingRaised);\n', '        resetOfferingStatus();\n', '    }\n', '\n', '    \n', '    function burnRemainTokenOffering() internal {\n', '        if (currentTokenOfferingRaised < currentTotalTokenOffering) {\n', '            uint256 remainTokenOffering = currentTotalTokenOffering.sub(currentTokenOfferingRaised);\n', '            _burn(owner, remainTokenOffering);\n', '        }\n', '    }\n', '\n', '    \n', '    function resetOfferingStatus() internal {\n', '        isOfferingStarted = false;        \n', '        startTime = 0;\n', '        endTime = 0;\n', '        currentTotalTokenOffering = 0;\n', '        currentTokenOfferingRaised = 0;\n', '        bonusRateOneEth = 0;\n', '        offeringEnabled = false;\n', '        isBurnInClose = false;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract WithdrawTrack is StandardToken, Ownable {\n', '\n', '\tstruct TrackInfo {\n', '\t\taddress to;\n', '\t\tuint256 amountToken;\n', '\t\tstring withdrawId;\n', '\t}\n', '\n', '\tmapping(string => TrackInfo) withdrawTracks;\n', '\n', '\tfunction withdrawToken(address _to, uint256 _amountToken, string _withdrawId) public onlyOwner returns (bool) {\n', '\t\tbool result = transfer(_to, _amountToken);\n', '\t\tif (result) {\n', '\t\t\twithdrawTracks[_withdrawId] = TrackInfo(_to, _amountToken, _withdrawId);\n', '\t\t}\n', '\t\treturn result;\n', '\t}\n', '\n', '\tfunction withdrawTrackOf(string _withdrawId) public view returns (address to, uint256 amountToken) {\n', '\t\tTrackInfo track = withdrawTracks[_withdrawId];\n', '\t\treturn (track.to, track.amountToken);\n', '\t}\n', '\n', '}\n', '\n', '\n', 'contract ContractSpendToken is StandardToken, Ownable {\n', '  mapping (address => address) private contractToReceiver;\n', '\n', '  function addContract(address _contractAdd, address _to) external onlyOwner returns (bool) {\n', '    require(_contractAdd != address(0x0));\n', '    require(_to != address(0x0));\n', '\n', '    contractToReceiver[_contractAdd] = _to;\n', '    return true;\n', '  }\n', '\n', '  function removeContract(address _contractAdd) external onlyOwner returns (bool) {\n', '    contractToReceiver[_contractAdd] = address(0x0);\n', '    return true;\n', '  }\n', '\n', '  function contractSpend(address _from, uint256 _value) public returns (bool) {\n', '    address _to = contractToReceiver[msg.sender];\n', '    require(_to != address(0x0));\n', '    require(_value <= balances[_from]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function getContractReceiver(address _contractAdd) public view onlyOwner returns (address) {\n', '    return contractToReceiver[_contractAdd];\n', '  }\n', '}\n', '\n', 'contract ContractiumToken is TokenOffering, WithdrawTrack, ContractSpendToken {\n', '\n', '    string public constant name = "Contractium";\n', '    string public constant symbol = "CTU";\n', '    uint8 public constant decimals = 18;\n', '  \n', '    uint256 public constant INITIAL_SUPPLY = 3000000000 * (10 ** uint256(decimals));\n', '  \n', '    uint256 public unitsOneEthCanBuy = 15000;\n', '\n', '   \n', '    uint256 internal totalWeiRaised;\n', '\n', '    event BuyToken(address from, uint256 weiAmount, uint256 tokenAmount);\n', '\n', '    function ContractiumToken() public {\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        \n', '        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '    }\n', '\n', '    function() public payable {\n', '\n', '        require(msg.sender != owner);\n', '\n', '       \n', '        uint256 amount = msg.value.mul(unitsOneEthCanBuy);\n', '\n', '       \n', '        uint256 amountBonus = msg.value.mul(bonusRateOneEth);\n', '        \n', '       \n', '        amount = amount.add(amountBonus);\n', '\n', '       \n', '        preValidatePurchase(amount);\n', '        require(balances[owner] >= amount);\n', '        \n', '        totalWeiRaised = totalWeiRaised.add(msg.value);\n', '    \n', '       \n', '        currentTokenOfferingRaised = currentTokenOfferingRaised.add(amount); \n', '        \n', '        balances[owner] = balances[owner].sub(amount);\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '\n', '        emit Transfer(owner, msg.sender, amount);\n', '        emit BuyToken(msg.sender, msg.value, amount);\n', '       \n', '        owner.transfer(msg.value);  \n', '                              \n', '    }\n', '\n', '    function batchTransfer(address[] _receivers, uint256[] _amounts) public returns(bool) {\n', '        uint256 cnt = _receivers.length;\n', '        require(cnt > 0 && cnt <= 20);\n', '        require(cnt == _amounts.length);\n', '\n', '        cnt = (uint8)(cnt);\n', '\n', '        uint256 totalAmount = 0;\n', '        for (uint8 i = 0; i < cnt; i++) {\n', '            totalAmount = totalAmount.add(_amounts[i]);\n', '        }\n', '\n', '        require(totalAmount <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(totalAmount);\n', '        for (i = 0; i < cnt; i++) {\n', '            balances[_receivers[i]] = balances[_receivers[i]].add(_amounts[i]);            \n', '            emit Transfer(msg.sender, _receivers[i], _amounts[i]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '}']
