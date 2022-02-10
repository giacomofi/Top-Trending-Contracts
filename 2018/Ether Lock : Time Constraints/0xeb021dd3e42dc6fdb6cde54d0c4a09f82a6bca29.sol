['pragma solidity ^0.4.18;\n', '//\n', '// FogLink OS Token\n', '// Author: FNK\n', '// Contact: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="2655535656495452664049414a4f484d084f49">[email&#160;protected]</a>\n', '// Telegram community: https://t.me/fnkofficial\n', '//\n', 'contract FNKOSToken {   \n', '    string public constant name         = "FNKOSToken";\n', '    string public constant symbol       = "FNKOS";\n', '    uint public constant decimals       = 18;\n', '    \n', '    uint256 fnkEthRate                  = 10 ** decimals;\n', '    uint256 fnkSupply                   = 1000000000;\n', '    uint256 public totalSupply          = fnkSupply * fnkEthRate;\n', '    uint256 public minInvEth            = 0.1 ether;\n', '    uint256 public maxInvEth            = 100.0 ether;\n', '    uint256 public sellStartTime        = 1524240000;           // 2018/4/21\n', '    uint256 public sellDeadline1        = sellStartTime + 30 days;\n', '    uint256 public sellDeadline2        = sellDeadline1 + 30 days;\n', '    uint256 public freezeDuration       = 30 days;\n', '    uint256 public ethFnkRate1          = 3600;\n', '    uint256 public ethFnkRate2          = 3600;\n', '\n', '    bool public running                 = true;\n', '    bool public buyable                 = true;\n', '    \n', '    address owner;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public whitelist;\n', '    mapping (address =>  uint256) whitelistLimit;\n', '\n', '    struct BalanceInfo {\n', '        uint256 balance;\n', '        uint256[] freezeAmount;\n', '        uint256[] releaseTime;\n', '    }\n', '    mapping (address => BalanceInfo) balances;\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event BeginRunning();\n', '    event PauseRunning();\n', '    event BeginSell();\n', '    event PauseSell();\n', '    event Burn(address indexed burner, uint256 val);\n', '    event Freeze(address indexed from, uint256 value);\n', '    \n', '    function FNKOSToken () public{\n', '        owner = msg.sender;\n', '        balances[owner].balance = totalSupply;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyWhitelist() {\n', '        require(whitelist[msg.sender] == true);\n', '        _;\n', '    }\n', '    \n', '    modifier isRunning(){\n', '        require(running);\n', '        _;\n', '    }\n', '    modifier isNotRunning(){\n', '        require(!running);\n', '        _;\n', '    }\n', '    modifier isBuyable(){\n', '        require(buyable && now >= sellStartTime && now <= sellDeadline2);\n', '        _;\n', '    }\n', '    modifier isNotBuyable(){\n', '        require(!buyable || now < sellStartTime || now > sellDeadline2);\n', '        _;\n', '    }\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    // 1eth = newRate tokens\n', '    function setPbulicOfferingPrice(uint256 _rate1, uint256 _rate2) onlyOwner public {\n', '        ethFnkRate1 = _rate1;\n', '        ethFnkRate2 = _rate2;       \n', '    }\n', '\n', '    //\n', '    function setPublicOfferingLimit(uint256 _minVal, uint256 _maxVal) onlyOwner public {\n', '        minInvEth   = _minVal;\n', '        maxInvEth   = _maxVal;\n', '    }\n', '    \n', '    function setPublicOfferingDate(uint256 _startTime, uint256 _deadLine1, uint256 _deadLine2) onlyOwner public {\n', '        sellStartTime = _startTime;\n', '        sellDeadline1   = _deadLine1;\n', '        sellDeadline2   = _deadLine2;\n', '    }\n', '        \n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        if (_newOwner !=    address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '    \n', '    function pause() onlyOwner isRunning    public   {\n', '        running = false;\n', '        PauseRunning();\n', '    }\n', '    \n', '    function start() onlyOwner isNotRunning public   {\n', '        running = true;\n', '        BeginRunning();\n', '    }\n', '\n', '    function pauseSell() onlyOwner  isBuyable isRunning public{\n', '        buyable = false;\n', '        PauseSell();\n', '    }\n', '    \n', '    function beginSell() onlyOwner  isNotBuyable isRunning  public{\n', '        buyable = true;\n', '        BeginSell();\n', '    }\n', '\n', '    //\n', '    // _amount in FNK, \n', '    //\n', '    function airDeliver(address _to,    uint256 _amount)  onlyOwner public {\n', '        require(owner != _to);\n', '        require(_amount > 0);\n', '        require(balances[owner].balance >= _amount);\n', '        \n', '        // take big number as wei\n', '        if(_amount < fnkSupply){\n', '            _amount = _amount * fnkEthRate;\n', '        }\n', '        balances[owner].balance = safeSub(balances[owner].balance, _amount);\n', '        balances[_to].balance = safeAdd(balances[_to].balance, _amount);\n', '        Transfer(owner, _to, _amount);\n', '    }\n', '    \n', '    \n', '    function airDeliverMulti(address[]  _addrs, uint256 _amount) onlyOwner public {\n', '        require(_addrs.length <=  255);\n', '        \n', '        for (uint8 i = 0; i < _addrs.length; i++)   {\n', '            airDeliver(_addrs[i],   _amount);\n', '        }\n', '    }\n', '    \n', '    function airDeliverStandalone(address[] _addrs, uint256[] _amounts) onlyOwner public {\n', '        require(_addrs.length <=  255);\n', '        require(_addrs.length ==     _amounts.length);\n', '        \n', '        for (uint8 i = 0; i < _addrs.length;    i++) {\n', '            airDeliver(_addrs[i],   _amounts[i]);\n', '        }\n', '    }\n', '\n', '    //\n', '    // _amount, _freezeAmount in FNK\n', '    //\n', '    function  freezeDeliver(address _to, uint _amount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {\n', '        require(owner != _to);\n', '        require(_freezeMonth > 0);\n', '        \n', '        uint average = _freezeAmount / _freezeMonth;\n', '        BalanceInfo storage bi = balances[_to];\n', '        uint[] memory fa = new uint[](_freezeMonth);\n', '        uint[] memory rt = new uint[](_freezeMonth);\n', '\n', '        if(_amount < fnkSupply){\n', '            _amount = _amount * fnkEthRate;\n', '            average = average * fnkEthRate;\n', '            _freezeAmount = _freezeAmount * fnkEthRate;\n', '        }\n', '        require(balances[owner].balance > _amount);\n', '        uint remainAmount = _freezeAmount;\n', '        \n', '        if(_unfreezeBeginTime == 0)\n', '            _unfreezeBeginTime = now + freezeDuration;\n', '        for(uint i=0;i<_freezeMonth-1;i++){\n', '            fa[i] = average;\n', '            rt[i] = _unfreezeBeginTime;\n', '            _unfreezeBeginTime += freezeDuration;\n', '            remainAmount = safeSub(remainAmount, average);\n', '        }\n', '        fa[i] = remainAmount;\n', '        rt[i] = _unfreezeBeginTime;\n', '        \n', '        bi.balance = safeAdd(bi.balance, _amount);\n', '        bi.freezeAmount = fa;\n', '        bi.releaseTime = rt;\n', '        balances[owner].balance = safeSub(balances[owner].balance, _amount);\n', '        Transfer(owner, _to, _amount);\n', '        Freeze(_to, _freezeAmount);\n', '    }\n', '    \n', '    function  freezeDeliverMuti(address[] _addrs, uint _deliverAmount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {\n', '        require(_addrs.length <=  255);\n', '        \n', '        for(uint i=0;i< _addrs.length;i++){\n', '            freezeDeliver(_addrs[i], _deliverAmount, _freezeAmount, _freezeMonth, _unfreezeBeginTime);\n', '        }\n', '    }\n', '\n', '    function  freezeDeliverMultiStandalone(address[] _addrs, uint[] _deliverAmounts, uint[] _freezeAmounts, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {\n', '        require(_addrs.length <=  255);\n', '        require(_addrs.length == _deliverAmounts.length);\n', '        require(_addrs.length == _freezeAmounts.length);\n', '        \n', '        for(uint i=0;i< _addrs.length;i++){\n', '            freezeDeliver(_addrs[i], _deliverAmounts[i], _freezeAmounts[i], _freezeMonth, _unfreezeBeginTime);\n', '        }\n', '    }\n', '    \n', '    // buy tokens directly\n', '    function () external payable {\n', '        buyTokens();\n', '    }\n', '\n', '    //\n', '    function buyTokens() payable isRunning isBuyable onlyWhitelist  public {\n', '        uint256 weiVal = msg.value;\n', '        address investor = msg.sender;\n', '        require(investor != address(0) && weiVal >= minInvEth && weiVal <= maxInvEth);\n', '        require(safeAdd(weiVal,whitelistLimit[investor]) <= maxInvEth);\n', '        \n', '        uint256 amount = 0;\n', '        if(now > sellDeadline1)\n', '            amount = safeMul(msg.value, ethFnkRate2);\n', '        else\n', '            amount = safeMul(msg.value, ethFnkRate1);   \n', '\n', '        whitelistLimit[investor] = safeAdd(weiVal, whitelistLimit[investor]);\n', '        \n', '        balances[owner].balance = safeSub(balances[owner].balance, amount);\n', '        balances[investor].balance = safeAdd(balances[investor].balance, amount);\n', '        Transfer(owner, investor, amount);\n', '    }\n', '\n', '    function addWhitelist(address[] _addrs) public onlyOwner {\n', '        require(_addrs.length <=  255);\n', '\n', '        for (uint8 i = 0; i < _addrs.length; i++) {\n', '            if (!whitelist[_addrs[i]]){\n', '                whitelist[_addrs[i]] = true;\n', '            }\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner].balance;\n', '    }\n', '    \n', '    function freezeOf(address _owner) constant  public returns (uint256) {\n', '        BalanceInfo storage bi = balances[_owner];\n', '        uint freezeAmount = 0;\n', '        uint t = now;\n', '        \n', '        for(uint i=0;i< bi.freezeAmount.length;i++){\n', '            if(t < bi.releaseTime[i])\n', '                freezeAmount += bi.freezeAmount[i];\n', '        }\n', '        return freezeAmount;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount)  isRunning onlyPayloadSize(2 *  32) public returns (bool success) {\n', '        require(_to != address(0));\n', '        uint freezeAmount = freezeOf(msg.sender);\n', '        uint256 _balance = safeSub(balances[msg.sender].balance, freezeAmount);\n', '        require(_amount <= _balance);\n', '        \n', '        balances[msg.sender].balance = safeSub(balances[msg.sender].balance,_amount);\n', '        balances[_to].balance = safeAdd(balances[_to].balance,_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _amount) isRunning onlyPayloadSize(3 * 32) public returns (bool   success) {\n', '        require(_from   != address(0) && _to != address(0));\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        uint freezeAmount = freezeOf(_from);\n', '        uint256 _balance = safeSub(balances[_from].balance, freezeAmount);\n', '        require(_amount <= _balance);\n', '        \n', '        balances[_from].balance = safeSub(balances[_from].balance,_amount);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);\n', '        balances[_to].balance = safeAdd(balances[_to].balance,_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) isRunning public returns (bool   success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { \n', '            return  false; \n', '        }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        require(this.balance > 0);\n', '        owner.transfer(this.balance);\n', '        Transfer(this, owner, this.balance);    \n', '    }\n', '    \n', '    function burn(address burner, uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender].balance);\n', '\n', '        balances[burner].balance = safeSub(balances[burner].balance, _value);\n', '        totalSupply = safeSub(totalSupply, _value);\n', '        fnkSupply = totalSupply / fnkEthRate;\n', '        Burn(burner, _value);\n', '    }\n', '    \n', '    function mint(address _target, uint256 _amount) onlyOwner public {\n', '        if(_target  == address(0))\n', '            _target = owner;\n', '        \n', '        balances[_target].balance = safeAdd(balances[_target].balance, _amount);\n', '        totalSupply = safeAdd(totalSupply,_amount);\n', '        fnkSupply = totalSupply / fnkEthRate;\n', '        Transfer(0, this, _amount);\n', '        Transfer(this, _target, _amount);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '//\n', '// FogLink OS Token\n', '// Author: FNK\n', '// Contact: support@foglink.io\n', '// Telegram community: https://t.me/fnkofficial\n', '//\n', 'contract FNKOSToken {   \n', '    string public constant name         = "FNKOSToken";\n', '    string public constant symbol       = "FNKOS";\n', '    uint public constant decimals       = 18;\n', '    \n', '    uint256 fnkEthRate                  = 10 ** decimals;\n', '    uint256 fnkSupply                   = 1000000000;\n', '    uint256 public totalSupply          = fnkSupply * fnkEthRate;\n', '    uint256 public minInvEth            = 0.1 ether;\n', '    uint256 public maxInvEth            = 100.0 ether;\n', '    uint256 public sellStartTime        = 1524240000;           // 2018/4/21\n', '    uint256 public sellDeadline1        = sellStartTime + 30 days;\n', '    uint256 public sellDeadline2        = sellDeadline1 + 30 days;\n', '    uint256 public freezeDuration       = 30 days;\n', '    uint256 public ethFnkRate1          = 3600;\n', '    uint256 public ethFnkRate2          = 3600;\n', '\n', '    bool public running                 = true;\n', '    bool public buyable                 = true;\n', '    \n', '    address owner;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public whitelist;\n', '    mapping (address =>  uint256) whitelistLimit;\n', '\n', '    struct BalanceInfo {\n', '        uint256 balance;\n', '        uint256[] freezeAmount;\n', '        uint256[] releaseTime;\n', '    }\n', '    mapping (address => BalanceInfo) balances;\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event BeginRunning();\n', '    event PauseRunning();\n', '    event BeginSell();\n', '    event PauseSell();\n', '    event Burn(address indexed burner, uint256 val);\n', '    event Freeze(address indexed from, uint256 value);\n', '    \n', '    function FNKOSToken () public{\n', '        owner = msg.sender;\n', '        balances[owner].balance = totalSupply;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyWhitelist() {\n', '        require(whitelist[msg.sender] == true);\n', '        _;\n', '    }\n', '    \n', '    modifier isRunning(){\n', '        require(running);\n', '        _;\n', '    }\n', '    modifier isNotRunning(){\n', '        require(!running);\n', '        _;\n', '    }\n', '    modifier isBuyable(){\n', '        require(buyable && now >= sellStartTime && now <= sellDeadline2);\n', '        _;\n', '    }\n', '    modifier isNotBuyable(){\n', '        require(!buyable || now < sellStartTime || now > sellDeadline2);\n', '        _;\n', '    }\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    // 1eth = newRate tokens\n', '    function setPbulicOfferingPrice(uint256 _rate1, uint256 _rate2) onlyOwner public {\n', '        ethFnkRate1 = _rate1;\n', '        ethFnkRate2 = _rate2;       \n', '    }\n', '\n', '    //\n', '    function setPublicOfferingLimit(uint256 _minVal, uint256 _maxVal) onlyOwner public {\n', '        minInvEth   = _minVal;\n', '        maxInvEth   = _maxVal;\n', '    }\n', '    \n', '    function setPublicOfferingDate(uint256 _startTime, uint256 _deadLine1, uint256 _deadLine2) onlyOwner public {\n', '        sellStartTime = _startTime;\n', '        sellDeadline1   = _deadLine1;\n', '        sellDeadline2   = _deadLine2;\n', '    }\n', '        \n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        if (_newOwner !=    address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '    \n', '    function pause() onlyOwner isRunning    public   {\n', '        running = false;\n', '        PauseRunning();\n', '    }\n', '    \n', '    function start() onlyOwner isNotRunning public   {\n', '        running = true;\n', '        BeginRunning();\n', '    }\n', '\n', '    function pauseSell() onlyOwner  isBuyable isRunning public{\n', '        buyable = false;\n', '        PauseSell();\n', '    }\n', '    \n', '    function beginSell() onlyOwner  isNotBuyable isRunning  public{\n', '        buyable = true;\n', '        BeginSell();\n', '    }\n', '\n', '    //\n', '    // _amount in FNK, \n', '    //\n', '    function airDeliver(address _to,    uint256 _amount)  onlyOwner public {\n', '        require(owner != _to);\n', '        require(_amount > 0);\n', '        require(balances[owner].balance >= _amount);\n', '        \n', '        // take big number as wei\n', '        if(_amount < fnkSupply){\n', '            _amount = _amount * fnkEthRate;\n', '        }\n', '        balances[owner].balance = safeSub(balances[owner].balance, _amount);\n', '        balances[_to].balance = safeAdd(balances[_to].balance, _amount);\n', '        Transfer(owner, _to, _amount);\n', '    }\n', '    \n', '    \n', '    function airDeliverMulti(address[]  _addrs, uint256 _amount) onlyOwner public {\n', '        require(_addrs.length <=  255);\n', '        \n', '        for (uint8 i = 0; i < _addrs.length; i++)   {\n', '            airDeliver(_addrs[i],   _amount);\n', '        }\n', '    }\n', '    \n', '    function airDeliverStandalone(address[] _addrs, uint256[] _amounts) onlyOwner public {\n', '        require(_addrs.length <=  255);\n', '        require(_addrs.length ==     _amounts.length);\n', '        \n', '        for (uint8 i = 0; i < _addrs.length;    i++) {\n', '            airDeliver(_addrs[i],   _amounts[i]);\n', '        }\n', '    }\n', '\n', '    //\n', '    // _amount, _freezeAmount in FNK\n', '    //\n', '    function  freezeDeliver(address _to, uint _amount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {\n', '        require(owner != _to);\n', '        require(_freezeMonth > 0);\n', '        \n', '        uint average = _freezeAmount / _freezeMonth;\n', '        BalanceInfo storage bi = balances[_to];\n', '        uint[] memory fa = new uint[](_freezeMonth);\n', '        uint[] memory rt = new uint[](_freezeMonth);\n', '\n', '        if(_amount < fnkSupply){\n', '            _amount = _amount * fnkEthRate;\n', '            average = average * fnkEthRate;\n', '            _freezeAmount = _freezeAmount * fnkEthRate;\n', '        }\n', '        require(balances[owner].balance > _amount);\n', '        uint remainAmount = _freezeAmount;\n', '        \n', '        if(_unfreezeBeginTime == 0)\n', '            _unfreezeBeginTime = now + freezeDuration;\n', '        for(uint i=0;i<_freezeMonth-1;i++){\n', '            fa[i] = average;\n', '            rt[i] = _unfreezeBeginTime;\n', '            _unfreezeBeginTime += freezeDuration;\n', '            remainAmount = safeSub(remainAmount, average);\n', '        }\n', '        fa[i] = remainAmount;\n', '        rt[i] = _unfreezeBeginTime;\n', '        \n', '        bi.balance = safeAdd(bi.balance, _amount);\n', '        bi.freezeAmount = fa;\n', '        bi.releaseTime = rt;\n', '        balances[owner].balance = safeSub(balances[owner].balance, _amount);\n', '        Transfer(owner, _to, _amount);\n', '        Freeze(_to, _freezeAmount);\n', '    }\n', '    \n', '    function  freezeDeliverMuti(address[] _addrs, uint _deliverAmount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {\n', '        require(_addrs.length <=  255);\n', '        \n', '        for(uint i=0;i< _addrs.length;i++){\n', '            freezeDeliver(_addrs[i], _deliverAmount, _freezeAmount, _freezeMonth, _unfreezeBeginTime);\n', '        }\n', '    }\n', '\n', '    function  freezeDeliverMultiStandalone(address[] _addrs, uint[] _deliverAmounts, uint[] _freezeAmounts, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {\n', '        require(_addrs.length <=  255);\n', '        require(_addrs.length == _deliverAmounts.length);\n', '        require(_addrs.length == _freezeAmounts.length);\n', '        \n', '        for(uint i=0;i< _addrs.length;i++){\n', '            freezeDeliver(_addrs[i], _deliverAmounts[i], _freezeAmounts[i], _freezeMonth, _unfreezeBeginTime);\n', '        }\n', '    }\n', '    \n', '    // buy tokens directly\n', '    function () external payable {\n', '        buyTokens();\n', '    }\n', '\n', '    //\n', '    function buyTokens() payable isRunning isBuyable onlyWhitelist  public {\n', '        uint256 weiVal = msg.value;\n', '        address investor = msg.sender;\n', '        require(investor != address(0) && weiVal >= minInvEth && weiVal <= maxInvEth);\n', '        require(safeAdd(weiVal,whitelistLimit[investor]) <= maxInvEth);\n', '        \n', '        uint256 amount = 0;\n', '        if(now > sellDeadline1)\n', '            amount = safeMul(msg.value, ethFnkRate2);\n', '        else\n', '            amount = safeMul(msg.value, ethFnkRate1);   \n', '\n', '        whitelistLimit[investor] = safeAdd(weiVal, whitelistLimit[investor]);\n', '        \n', '        balances[owner].balance = safeSub(balances[owner].balance, amount);\n', '        balances[investor].balance = safeAdd(balances[investor].balance, amount);\n', '        Transfer(owner, investor, amount);\n', '    }\n', '\n', '    function addWhitelist(address[] _addrs) public onlyOwner {\n', '        require(_addrs.length <=  255);\n', '\n', '        for (uint8 i = 0; i < _addrs.length; i++) {\n', '            if (!whitelist[_addrs[i]]){\n', '                whitelist[_addrs[i]] = true;\n', '            }\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner].balance;\n', '    }\n', '    \n', '    function freezeOf(address _owner) constant  public returns (uint256) {\n', '        BalanceInfo storage bi = balances[_owner];\n', '        uint freezeAmount = 0;\n', '        uint t = now;\n', '        \n', '        for(uint i=0;i< bi.freezeAmount.length;i++){\n', '            if(t < bi.releaseTime[i])\n', '                freezeAmount += bi.freezeAmount[i];\n', '        }\n', '        return freezeAmount;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount)  isRunning onlyPayloadSize(2 *  32) public returns (bool success) {\n', '        require(_to != address(0));\n', '        uint freezeAmount = freezeOf(msg.sender);\n', '        uint256 _balance = safeSub(balances[msg.sender].balance, freezeAmount);\n', '        require(_amount <= _balance);\n', '        \n', '        balances[msg.sender].balance = safeSub(balances[msg.sender].balance,_amount);\n', '        balances[_to].balance = safeAdd(balances[_to].balance,_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _amount) isRunning onlyPayloadSize(3 * 32) public returns (bool   success) {\n', '        require(_from   != address(0) && _to != address(0));\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        uint freezeAmount = freezeOf(_from);\n', '        uint256 _balance = safeSub(balances[_from].balance, freezeAmount);\n', '        require(_amount <= _balance);\n', '        \n', '        balances[_from].balance = safeSub(balances[_from].balance,_amount);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);\n', '        balances[_to].balance = safeAdd(balances[_to].balance,_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) isRunning public returns (bool   success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { \n', '            return  false; \n', '        }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        require(this.balance > 0);\n', '        owner.transfer(this.balance);\n', '        Transfer(this, owner, this.balance);    \n', '    }\n', '    \n', '    function burn(address burner, uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender].balance);\n', '\n', '        balances[burner].balance = safeSub(balances[burner].balance, _value);\n', '        totalSupply = safeSub(totalSupply, _value);\n', '        fnkSupply = totalSupply / fnkEthRate;\n', '        Burn(burner, _value);\n', '    }\n', '    \n', '    function mint(address _target, uint256 _amount) onlyOwner public {\n', '        if(_target  == address(0))\n', '            _target = owner;\n', '        \n', '        balances[_target].balance = safeAdd(balances[_target].balance, _amount);\n', '        totalSupply = safeAdd(totalSupply,_amount);\n', '        fnkSupply = totalSupply / fnkEthRate;\n', '        Transfer(0, this, _amount);\n', '        Transfer(this, _target, _amount);\n', '    }\n', '}']
