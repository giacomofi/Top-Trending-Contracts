['pragma solidity 0.4.24;\n', '\n', 'library AddressSet {\n', '\n', '    struct Instance {\n', '        address[] list;\n', '        mapping(address => uint256) idx; // actually stores indexes incremented by 1\n', '    }\n', '\n', '    function push(Instance storage self, address addr) internal returns (bool) {\n', '        if (self.idx[addr] != 0) return false;\n', '        self.idx[addr] = self.list.push(addr);\n', '        return true;\n', '    }\n', '\n', '    function sizeOf(Instance storage self) internal view returns (uint256) {\n', '        return self.list.length;\n', '    }\n', '\n', '    function getAddress(Instance storage self, uint256 index) internal view returns (address) {\n', '        return (index < self.list.length) ? self.list[index] : address(0);\n', '    }\n', '\n', '    function remove(Instance storage self, address addr) internal returns (bool) {\n', '        if (self.idx[addr] == 0) return false;\n', '        uint256 idx = self.idx[addr];\n', '        delete self.idx[addr];\n', '        if (self.list.length == idx) {\n', '            self.list.length--;\n', '        } else {\n', '            address last = self.list[self.list.length-1];\n', '            self.list.length--;\n', '            self.list[idx-1] = last;\n', '            self.idx[last] = idx;\n', '        }\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() external view returns (uint256 _totalSupply);\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract UHCToken is ERC20 {\n', '    using SafeMath for uint256;\n', '    using AddressSet for AddressSet.Instance;\n', '\n', '    address public owner;\n', '    address public subowner;\n', '\n', '    bool    public              paused         = false;\n', '    bool    public              contractEnable = true;\n', '\n', '    string  public              name = "UHC";\n', '    string  public              symbol = "UHC";\n', '    uint8   public              decimals = 4;\n', '    uint256 private             summarySupply;\n', '    uint8   public              transferFeePercent = 3;\n', '    uint8   public              refererFeePercent = 1;\n', '\n', '    struct account{\n', '        uint256 balance;\n', '        uint8 group;\n', '        uint8 status;\n', '        address referer;\n', '        bool isBlocked;\n', '    }\n', '\n', '    mapping(address => account)                      private   accounts;\n', '    mapping(address => mapping (address => uint256)) private   allowed;\n', '    mapping(bytes => address)                        private   promos;\n', '\n', '    AddressSet.Instance                             private   holders;\n', '\n', '    struct groupPolicy {\n', '        uint8 _default;\n', '        uint8 _backend;\n', '        uint8 _admin;\n', '        uint8 _owner;\n', '    }\n', '\n', '    groupPolicy public groupPolicyInstance = groupPolicy(0, 3, 4, 9);\n', '\n', '    event EvGroupChanged(address indexed _address, uint8 _oldgroup, uint8 _newgroup);\n', '    event EvMigration(address indexed _address, uint256 _balance, uint256 _secret);\n', '    event EvUpdateStatus(address indexed _address, uint8 _oldstatus, uint8 _newstatus);\n', '    event EvSetReferer(address indexed _referal, address _referer);\n', '    event SwitchPause(bool isPaused);\n', '\n', '    constructor (string _name, string _symbol, uint8 _decimals,uint256 _summarySupply, uint8 _transferFeePercent, uint8 _refererFeePercent) public {\n', '        require(_refererFeePercent < _transferFeePercent);\n', '        owner = msg.sender;\n', '\n', '        accounts[owner] = account(_summarySupply,groupPolicyInstance._owner,3, address(0), false);\n', '\n', '        holders.push(msg.sender);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        summarySupply = _summarySupply;\n', '        transferFeePercent = _transferFeePercent;\n', '        refererFeePercent = _refererFeePercent;\n', '        emit Transfer(address(0), msg.sender, _summarySupply);\n', '    }\n', '\n', '    modifier minGroup(int _require) {\n', '        require(accounts[msg.sender].group >= _require);\n', '        _;\n', '    }\n', '\n', '    modifier onlySubowner() {\n', '        require(msg.sender == subowner);\n', '        _;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused || accounts[msg.sender].group >= groupPolicyInstance._backend);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenNotMigrating {\n', '        require(contractEnable);\n', '        _;\n', '    }\n', '\n', '    modifier whenMigrating {\n', '        require(!contractEnable);\n', '        _;\n', '    }\n', '\n', '    function servicePause() minGroup(groupPolicyInstance._admin) whenNotPaused public {\n', '        paused = true;\n', '        emit SwitchPause(paused);\n', '    }\n', '\n', '    function serviceUnpause() minGroup(groupPolicyInstance._admin) whenPaused public {\n', '        paused = false;\n', '        emit SwitchPause(paused);\n', '    }\n', '\n', '    function serviceGroupChange(address _address, uint8 _group) minGroup(groupPolicyInstance._admin) external returns(uint8) {\n', '        require(_address != address(0));\n', '        require(_group <= groupPolicyInstance._admin);\n', '\n', '        uint8 old = accounts[_address].group;\n', '        require(old < accounts[msg.sender].group);\n', '\n', '        accounts[_address].group = _group;\n', '        emit EvGroupChanged(_address, old, _group);\n', '\n', '        return accounts[_address].group;\n', '    }\n', '\n', '    function serviceTransferOwnership(address newOwner) minGroup(groupPolicyInstance._owner) external {\n', '        require(newOwner != address(0));\n', '\n', '        subowner = newOwner;\n', '    }\n', '\n', '    function serviceClaimOwnership() onlySubowner() external {\n', '        address temp = owner;\n', '        uint256 value = accounts[owner].balance;\n', '\n', '        accounts[owner].balance = accounts[owner].balance.sub(value);\n', '        holders.remove(owner);\n', '        accounts[msg.sender].balance = accounts[msg.sender].balance.add(value);\n', '        holders.push(msg.sender);\n', '\n', '        owner = msg.sender;\n', '        subowner = address(0);\n', '\n', '        delete accounts[temp].group;\n', '        uint8 oldGroup = accounts[msg.sender].group;\n', '        accounts[msg.sender].group = groupPolicyInstance._owner;\n', '\n', '        emit EvGroupChanged(msg.sender, oldGroup, groupPolicyInstance._owner);\n', '        emit Transfer(temp, owner, value);\n', '    }\n', '\n', '    function serviceSwitchTransferAbility(address _address) external minGroup(groupPolicyInstance._admin) returns(bool) {\n', '        require(accounts[_address].group < accounts[msg.sender].group);\n', '\n', '        accounts[_address].isBlocked = !accounts[_address].isBlocked;\n', '\n', '        return true;\n', '    }\n', '\n', '    function serviceUpdateTransferFeePercent(uint8 newFee) external minGroup(groupPolicyInstance._admin) {\n', '        require(newFee < 100);\n', '        require(newFee > refererFeePercent);\n', '        transferFeePercent = newFee;\n', '    }\n', '\n', '    function serviceUpdateRefererFeePercent(uint8 newFee) external minGroup(groupPolicyInstance._admin) {\n', '        require(newFee < 100);\n', '        require(transferFeePercent > newFee);\n', '        refererFeePercent = newFee;\n', '    }\n', '\n', '    function serviceSetPromo(bytes num, address _address) external minGroup(groupPolicyInstance._admin) {\n', '        promos[num] = _address;\n', '    }\n', '\n', '    function backendSetStatus(address _address, uint8 status) external minGroup(groupPolicyInstance._backend) returns(bool){\n', '        require(_address != address(0));\n', '        require(status >= 0 && status <= 4);\n', '        uint8 oldStatus = accounts[_address].status;\n', '        accounts[_address].status = status;\n', '\n', '        emit EvUpdateStatus(_address, oldStatus, status);\n', '\n', '        return true;\n', '    }\n', '\n', '    function backendSetReferer(address _referal, address _referer) external minGroup(groupPolicyInstance._backend) returns(bool) {\n', '        require(accounts[_referal].referer == address(0));\n', '        require(_referal != address(0));\n', '        require(_referal != _referer);\n', '        require(accounts[_referal].referer != _referer);\n', '\n', '        accounts[_referal].referer = _referer;\n', '\n', '        emit EvSetReferer(_referal, _referer);\n', '\n', '        return true;\n', '    }\n', '\n', '    function backendSendBonus(address _to, uint256 _value) external minGroup(groupPolicyInstance._backend) returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value > 0);\n', '        require(accounts[owner].balance >= _value);\n', '\n', '        accounts[owner].balance = accounts[owner].balance.sub(_value);\n', '        accounts[_to].balance = accounts[_to].balance.add(_value);\n', '\n', '        emit Transfer(owner, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function backendRefund(address _from, uint256 _value) external minGroup(groupPolicyInstance._backend) returns(uint256 balance) {\n', '        require(_from != address(0));\n', '        require(_value > 0);\n', '        require(accounts[_from].balance >= _value);\n', ' \n', '        accounts[_from].balance = accounts[_from].balance.sub(_value);\n', '        accounts[owner].balance = accounts[owner].balance.add(_value);\n', '        if(accounts[_from].balance == 0){\n', '            holders.remove(_from);\n', '        }\n', '        emit Transfer(_from, owner, _value);\n', '        return accounts[_from].balance;\n', '    }\n', '\n', '    function getGroup(address _check) external view returns(uint8 _group) {\n', '        return accounts[_check].group;\n', '    }\n', '\n', '    function getHoldersLength() external view returns(uint256){\n', '        return holders.sizeOf();\n', '    }\n', '\n', '    function getHolderByIndex(uint256 _index) external view returns(address){\n', '        return holders.getAddress(_index);\n', '    }\n', '\n', '    function getPromoAddress(bytes _promo) external view returns(address) {\n', '        return promos[_promo];\n', '    }\n', '\n', '    function getAddressTransferAbility(address _check) external view returns(bool) {\n', '        return !accounts[_check].isBlocked;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success) {\n', '        return _transfer(msg.sender, _to, address(0), _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {\n', '        return _transfer(_from, _to, msg.sender, _value);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, address _allow, uint256 _value) minGroup(groupPolicyInstance._default) whenNotMigrating whenNotPaused internal returns(bool) {\n', '        require(!accounts[_from].isBlocked);\n', '        require(_from != address(0));\n', '        require(_to != address(0));\n', '        uint256 transferFee = accounts[_from].group == 0 ? _value.div(100).mul(accounts[_from].referer == address(0) ? transferFeePercent : transferFeePercent - refererFeePercent) : 0;\n', '        uint256 transferRefererFee = accounts[_from].referer == address(0) || accounts[_from].group != 0 ? 0 : _value.div(100).mul(refererFeePercent);\n', '        uint256 summaryValue = _value.add(transferFee).add(transferRefererFee);\n', '        require(accounts[_from].balance >= summaryValue);\n', '        require(_allow == address(0) || allowed[_from][_allow] >= summaryValue);\n', '\n', '        accounts[_from].balance = accounts[_from].balance.sub(summaryValue);\n', '        if(_allow != address(0)) {\n', '            allowed[_from][_allow] = allowed[_from][_allow].sub(summaryValue);\n', '        }\n', '\n', '        if(accounts[_from].balance == 0){\n', '            holders.remove(_from);\n', '        }\n', '        accounts[_to].balance = accounts[_to].balance.add(_value);\n', '        holders.push(_to);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        if(transferFee > 0) {\n', '            accounts[owner].balance = accounts[owner].balance.add(transferFee);\n', '            emit Transfer(_from, owner, transferFee);\n', '        }\n', '\n', '        if(transferRefererFee > 0) {\n', '            accounts[accounts[_from].referer].balance = accounts[accounts[_from].referer].balance.add(transferRefererFee);\n', '            holders.push(accounts[_from].referer);\n', '            emit Transfer(_from, accounts[_from].referer, transferRefererFee);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) minGroup(groupPolicyInstance._default) whenNotPaused external returns (bool success) {\n', '        require (_value == 0 || allowed[msg.sender][_spender] == 0);\n', '        require(_spender != address(0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint256 _addedValue) minGroup(groupPolicyInstance._default) whenNotPaused external returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) minGroup(groupPolicyInstance._default) whenNotPaused external returns (bool)\n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance) {\n', '        return accounts[_owner].balance;\n', '    }\n', '\n', '    function statusOf(address _owner) external view returns (uint8) {\n', '        return accounts[_owner].status;\n', '    }\n', '\n', '    function refererOf(address _owner) external constant returns (address) {\n', '        return accounts[_owner].referer;\n', '    }\n', '\n', '    function totalSupply() external constant returns (uint256 _totalSupply) {\n', '        _totalSupply = summarySupply;\n', '    }\n', '\n', '    function settingsSwitchState() external minGroup(groupPolicyInstance._owner) returns (bool state) {\n', '\n', '        contractEnable = !contractEnable;\n', '\n', '        return contractEnable;\n', '    }\n', '\n', '    function userMigration(uint256 _secret) external whenMigrating returns (bool successful) {\n', '        uint256 balance = accounts[msg.sender].balance;\n', '\n', '        require (balance > 0);\n', '\n', '        accounts[msg.sender].balance = accounts[msg.sender].balance.sub(balance);\n', '        holders.remove(msg.sender);\n', '        accounts[owner].balance = accounts[owner].balance.add(balance);\n', '        holders.push(owner);\n', '        emit EvMigration(msg.sender, balance, _secret);\n', '        emit Transfer(msg.sender, owner, balance);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract EtherReceiver {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public      startTime;\n', '    uint256 public      durationOfStatusSell;\n', '    uint256 public      weiPerMinToken;\n', '    uint256 public      softcap;\n', '    uint256 public      totalSold;\n', '    uint8   public      referalBonusPercent;\n', '    uint8   public      refererFeePercent;\n', '\n', '    uint256 public      refundStageStartTime;\n', '    uint256 public      maxRefundStageDuration;\n', '\n', '    mapping(uint256 => uint256) public      soldOnVersion;\n', '    mapping(address => uint8)   private     group;\n', '\n', '    uint256 public     version;\n', '    uint256 public      etherTotal;\n', '\n', '    bool    public     isActive = false;\n', '    \n', '    struct Account{\n', '        // Hack to save gas\n', '        // if > 0 then value + 1\n', '        uint256 spent;\n', '        uint256 allTokens;\n', '        uint256 statusTokens;\n', '        uint256 version;\n', '        // if > 0 then value + 1\n', '        uint256 versionTokens;\n', '        // if > 0 then value + 1\n', '        uint256 versionStatusTokens;\n', '        // if > 0 then value + 1\n', '        uint256 versionRefererTokens;\n', '        uint8 versionBeforeStatus;\n', '    }\n', '\n', '    mapping(address => Account) public accounts;\n', '\n', '    struct groupPolicy {\n', '        uint8 _backend;\n', '        uint8 _admin;\n', '    }\n', '\n', '    groupPolicy public groupPolicyInstance = groupPolicy(3,4);\n', '\n', '    uint256[4] public statusMinBorders;\n', '\n', '    UHCToken public            token;\n', '\n', '    event EvAccountPurchase(address indexed _address, uint256 _newspent, uint256 _newtokens, uint256 _totalsold);\n', '    //Используем на бекенде для возврата BTC по версии\n', '    event EvWithdraw(address indexed _address, uint256 _spent, uint256 _version);\n', '    event EvSwitchActivate(address indexed _switcher, bool _isActivate);\n', '    event EvSellStatusToken(address indexed _owner, uint256 _oldtokens, uint256 _newtokens);\n', '    event EvUpdateVersion(address indexed _owner, uint256 _version);\n', '    event EvGroupChanged(address _address, uint8 _oldgroup, uint8 _newgroup);\n', '\n', '    constructor (\n', '        address _token,\n', '        uint256 _startTime,\n', '        uint256 _weiPerMinToken, \n', '        uint256 _softcap,\n', '        uint256 _durationOfStatusSell,\n', '        uint[4] _statusMinBorders, \n', '        uint8 _referalBonusPercent, \n', '        uint8 _refererFeePercent,\n', '        uint256 _maxRefundStageDuration,\n', '        bool _activate\n', '    ) public\n', '    {\n', '        token = UHCToken(_token);\n', '        startTime = _startTime;\n', '        weiPerMinToken = _weiPerMinToken;\n', '        softcap = _softcap;\n', '        durationOfStatusSell = _durationOfStatusSell;\n', '        statusMinBorders = _statusMinBorders;\n', '        referalBonusPercent = _referalBonusPercent;\n', '        refererFeePercent = _refererFeePercent;\n', '        maxRefundStageDuration = _maxRefundStageDuration;\n', '        isActive = _activate;\n', '        group[msg.sender] = groupPolicyInstance._admin;\n', '    }\n', '\n', '    modifier onlyOwner(){\n', '        require(msg.sender == token.owner());\n', '        _;\n', '    }\n', '\n', '    modifier saleIsOn() {\n', '        require(now > startTime && isActive && soldOnVersion[version] < softcap);\n', '        _;\n', '    }\n', '\n', '    modifier minGroup(int _require) {\n', '        require(group[msg.sender] >= _require || msg.sender == token.owner());\n', '        _;\n', '    }\n', '\n', '    function refresh(\n', '        uint256 _startTime, \n', '        uint256 _softcap,\n', '        uint256 _durationOfStatusSell,\n', '        uint[4] _statusMinBorders,\n', '        uint8 _referalBonusPercent, \n', '        uint8 _refererFeePercent,\n', '        uint256 _maxRefundStageDuration,\n', '        bool _activate\n', '    ) \n', '        external\n', '        minGroup(groupPolicyInstance._admin) \n', '    {\n', '        require(!isActive && etherTotal == 0);\n', '        startTime = _startTime;\n', '        softcap = _softcap;\n', '        durationOfStatusSell = _durationOfStatusSell;\n', '        statusMinBorders = _statusMinBorders;\n', '        referalBonusPercent = _referalBonusPercent;\n', '        refererFeePercent = _refererFeePercent;\n', '        version = version.add(1);\n', '        maxRefundStageDuration = _maxRefundStageDuration;\n', '        isActive = _activate;\n', '\n', '        refundStageStartTime = 0;\n', '\n', '        emit EvUpdateVersion(msg.sender, version);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) external minGroup(groupPolicyInstance._backend) saleIsOn() {\n', '        token.transfer( _to, _value);\n', '\n', '        updateAccountInfo(_to, 0, _value);\n', '\n', '        address referer = token.refererOf(_to);\n', '        trySendBonuses(_to, referer, _value);\n', '    }\n', '\n', '    function withdraw() external minGroup(groupPolicyInstance._admin) returns(bool success) {\n', '        require(!isActive && (soldOnVersion[version] >= softcap || now > refundStageStartTime + maxRefundStageDuration));\n', '        uint256 contractBalance = address(this).balance;\n', '        token.owner().transfer(contractBalance);\n', '        etherTotal = 0;\n', '\n', '        return true;\n', '    }\n', '\n', '    function activateVersion(bool _isActive) external minGroup(groupPolicyInstance._admin) {\n', '        require(isActive != _isActive);\n', '        isActive = _isActive;\n', '        refundStageStartTime = isActive ? 0 : now;\n', '        emit EvSwitchActivate(msg.sender, isActive);\n', '    }\n', '\n', '    function setWeiPerMinToken(uint256 _weiPerMinToken) external minGroup(groupPolicyInstance._backend)  {\n', '        require (_weiPerMinToken > 0);\n', '\n', '        weiPerMinToken = _weiPerMinToken;\n', '    }\n', '\n', '    function refund() external {\n', '        require(!isActive && soldOnVersion[version] < softcap && now <= refundStageStartTime + maxRefundStageDuration);\n', '\n', '        tryUpdateVersion(msg.sender);\n', '\n', '        Account storage account = accounts[msg.sender];\n', '\n', '        require(account.spent > 1);\n', '\n', '        uint256 value = account.spent.sub(1);\n', '        account.spent = 1;\n', '        etherTotal = etherTotal.sub(value);\n', '        \n', '        msg.sender.transfer(value);\n', '\n', '        if(account.versionTokens > 0) {\n', '            token.backendRefund(msg.sender, account.versionTokens.sub(1));\n', '            account.allTokens = account.allTokens.sub(account.versionTokens.sub(1));\n', '            account.statusTokens = account.statusTokens.sub(account.versionStatusTokens.sub(1));\n', '            account.versionStatusTokens = 1;\n', '            account.versionTokens = 1;\n', '        }\n', '\n', '        address referer = token.refererOf(msg.sender);\n', '        if(account.versionRefererTokens > 0 && referer != address(0)) {\n', '            token.backendRefund(referer, account.versionRefererTokens.sub(1));\n', '            account.versionRefererTokens = 1;\n', '        }\n', '\n', '        uint8 currentStatus = token.statusOf(msg.sender);\n', '        if(account.versionBeforeStatus != currentStatus){\n', '            token.backendSetStatus(msg.sender, account.versionBeforeStatus);\n', '        }\n', '\n', '        emit EvWithdraw(msg.sender, value, version);\n', '    }\n', '\n', '    function serviceGroupChange(address _address, uint8 _group) minGroup(groupPolicyInstance._admin) external returns(uint8) {\n', '        uint8 old = group[_address];\n', '        if(old <= groupPolicyInstance._admin) {\n', '            group[_address] = _group;\n', '            emit EvGroupChanged(_address, old, _group);\n', '        }\n', '        return group[_address];\n', '    }\n', '\n', '    function () external saleIsOn() payable{\n', '        uint256 tokenCount = msg.value.div(weiPerMinToken);\n', '        require(tokenCount > 0);\n', '\n', '        token.transfer( msg.sender, tokenCount);\n', '\n', '        updateAccountInfo(msg.sender, msg.value, tokenCount);\n', '\n', '        address referer = token.refererOf(msg.sender);\n', '        if (msg.data.length > 0 && referer == address(0)) {\n', '            referer = token.getPromoAddress(bytes(msg.data));\n', '            if(referer != address(0)) {\n', '                require(referer != msg.sender);\n', '                require(token.backendSetReferer(msg.sender, referer));\n', '            }\n', '        }\n', '        trySendBonuses(msg.sender, referer, tokenCount);\n', '    }\n', '\n', '    function updateAccountInfo(address _address, uint256 incSpent, uint256 incTokenCount) private returns(bool){\n', '        tryUpdateVersion(_address);\n', '        Account storage account = accounts[_address];\n', '        account.spent = account.spent.add(incSpent);\n', '        account.allTokens = account.allTokens.add(incTokenCount);\n', '        \n', '        account.versionTokens = account.versionTokens.add(incTokenCount);\n', '        \n', '        totalSold = totalSold.add(incTokenCount);\n', '        soldOnVersion[version] = soldOnVersion[version].add(incTokenCount);\n', '        etherTotal = etherTotal.add(incSpent);\n', '\n', '        emit EvAccountPurchase(_address, account.spent.sub(1), account.allTokens, totalSold);\n', '\n', '        if(now < startTime + durationOfStatusSell && now >= startTime){\n', '\n', '            uint256 lastStatusTokens = account.statusTokens;\n', '\n', '            account.statusTokens = account.statusTokens.add(incTokenCount);\n', '            account.versionStatusTokens = account.versionStatusTokens.add(incTokenCount);\n', '\n', '            uint256 currentStatus = uint256(token.statusOf(_address));\n', '\n', '            uint256 newStatus = currentStatus;\n', '\n', '            for(uint256 i = currentStatus; i < 4; i++){\n', '\n', '                if(account.statusTokens > statusMinBorders[i]){\n', '                    newStatus = i + 1;\n', '                } else {\n', '                    break;\n', '                }\n', '            }\n', '            if(currentStatus < newStatus){\n', '                token.backendSetStatus(_address, uint8(newStatus));\n', '            }\n', '            emit EvSellStatusToken(_address, lastStatusTokens, account.statusTokens);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function tryUpdateVersion(address _address) private {\n', '        Account storage account = accounts[_address];\n', '        if(account.version != version){\n', '            account.version = version;\n', '            account.versionBeforeStatus = token.statusOf(_address);\n', '        }\n', '        if(account.version != version || account.spent == 0){\n', '            account.spent = 1;\n', '            account.versionTokens = 1;\n', '            account.versionRefererTokens = 1;\n', '            account.versionStatusTokens = 1;\n', '        }\n', '    }\n', '\n', '    function trySendBonuses(address _address, address _referer, uint256 _tokenCount) private {\n', '        if(_referer != address(0)) {\n', '            uint256 refererFee = _tokenCount.div(100).mul(refererFeePercent);\n', '            uint256 referalBonus = _tokenCount.div(100).mul(referalBonusPercent);\n', '            if(refererFee > 0) {\n', '                token.backendSendBonus(_referer, refererFee);\n', '                \n', '                accounts[_address].versionRefererTokens = accounts[_address].versionRefererTokens.add(refererFee);\n', '                \n', '            }\n', '            if(referalBonus > 0) {\n', '                token.backendSendBonus(_address, referalBonus);\n', '                \n', '                accounts[_address].versionTokens = accounts[_address].versionTokens.add(referalBonus);\n', '                accounts[_address].allTokens = accounts[_address].allTokens.add(referalBonus);\n', '            }\n', '        }\n', '    }\n', '\n', '    function calculateTokenCount(uint256 weiAmount) external view returns(uint256 summary){\n', '        return weiAmount.div(weiPerMinToken);\n', '    }\n', '\n', '    function isSelling() external view returns(bool){\n', '        return now > startTime && soldOnVersion[version] < softcap && isActive;\n', '    }\n', '\n', '    function getGroup(address _check) external view returns(uint8 _group) {\n', '        return group[_check];\n', '    }\n', '}']