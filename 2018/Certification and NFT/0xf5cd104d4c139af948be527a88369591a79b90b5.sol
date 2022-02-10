['contract Partner {\n', '    function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);\n', '}\n', '\n', 'contract COE {\n', '\n', '    string public name = "CoEval";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "COE";\n', '\n', '\n', '    address public _owner;\n', '    address public _dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;\n', '    address _pMine = 0x76D05E325973D7693Bb854ED258431aC7DBBeDc3;\n', '    address public _devFeesAddr;\n', '    uint256 public _tokePerEth = 177000000000000000;\n', '    bool public _coldStorage = true;\n', '    bool public _receiveEth = true;\n', '\n', '    // fees vars - added for future extensibility purposes only\n', '    bool _feesEnabled = false;\n', '    bool _payFees = false;\n', '    uint256 _fees;  // the calculation expects % * 100 (so 10% is 1000)\n', '    uint256 _lifeVal = 0;\n', '    uint256 _feeLimit = 0;\n', '    uint256 _devFees = 0;\n', '\n', '    uint256 public _totalSupply = 100000 * 1 ether;\n', '    uint256 public _frozenTokens = 0;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Exchanged(address indexed _from, address indexed _to, uint _value);\n', '    // Storage\n', '    mapping (address => uint256) public balances;\n', '\n', '    // list of contract addresses that can request tokens\n', '    // use add/remove functions to update\n', '    mapping (address => bool) public exchangePartners;\n', '\n', '    // permitted exch partners and associated token rates\n', '    // rate is X target tokens per Y incoming so newTokens = Tokens/Rate\n', '    mapping (address => uint256) public exchangeRates;\n', '\n', '    function MNY() {\n', '        _owner = msg.sender;\n', '        preMine();\n', '    }\n', '\n', '    function preMine() internal {\n', '        balances[_dev] = 32664750000000000000000;\n', '        Transfer(this, _pMine, 32664750000000000000000);\n', '        _totalSupply = sub(_totalSupply, 32664750000000000000000);\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public {\n', '        // sender must have enough tokens to transfer\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        if(_to == address(this)) {\n', '            // WARNING: if you transfer tokens back to the contract you will lose them\n', '            // use the exchange function to exchange with approved partner contracts\n', '            _totalSupply = add(_totalSupply, _value);\n', '            balances[msg.sender] = sub(balanceOf(msg.sender), _value);\n', '            Transfer(msg.sender, _to, _value);\n', '        }\n', '        else {\n', '            uint codeLength;\n', '\n', '            assembly {\n', '                codeLength := extcodesize(_to)\n', '            }\n', '\n', '            // we decided that we don&#39;t want to lose tokens into OTHER contracts that aren&#39;t exchange partners\n', '            require(codeLength == 0);\n', '\n', '            balances[msg.sender] = sub(balanceOf(msg.sender), _value);\n', '            balances[_to] = add(balances[_to], _value);\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public {\n', '        /// sender must have enough tokens to transfer\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        if(_to == address(this)) {\n', '            // WARNING: if you transfer tokens back to the contract you will lose them\n', '            // use the exchange function to exchange for tokens with approved partner contracts\n', '            _totalSupply = add(_totalSupply, _value);\n', '            balances[msg.sender] = sub(balanceOf(msg.sender), _value);\n', '            Transfer(msg.sender, _to, _value);\n', '        }\n', '        else {\n', '            uint codeLength;\n', '\n', '            assembly {\n', '                codeLength := extcodesize(_to)\n', '            }\n', '\n', '            // we decided that we don&#39;t want to lose tokens into OTHER contracts that aren&#39;t exchange partners\n', '            require(codeLength == 0);\n', '\n', '            balances[msg.sender] = sub(balanceOf(msg.sender), _value);\n', '            balances[_to] = add(balances[_to], _value);\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '        }\n', '    }\n', '\n', '    function exchange(address _partner, uint _amount) public {\n', '        require(balances[msg.sender] >= _amount);\n', '\n', '        // intended partner addy must be a contract\n', '        uint codeLength;\n', '        assembly {\n', '        // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_partner)\n', '        }\n', '        require(codeLength > 0);\n', '\n', '        require(exchangePartners[_partner]);\n', '        require(requestTokensFromOtherContract(_partner, this, msg.sender, _amount));\n', '\n', '        if(_coldStorage) {\n', '            // put the tokens from this contract into cold storage if we need to\n', '            // (NB: if these are in reality to be burnt, we just never defrost them)\n', '            _frozenTokens = add(_frozenTokens, _amount);\n', '        }\n', '        else {\n', '            // or return them to the available supply if not\n', '            _totalSupply = add(_totalSupply, _amount);\n', '        }\n', '\n', '        balances[msg.sender] = sub(balanceOf(msg.sender), _amount);\n', '        Exchanged(msg.sender, _partner, _amount);\n', '        Transfer(msg.sender, this, _amount);\n', '    }\n', '\n', '    // fallback to receive ETH into contract and send tokens back based on current exchange rate\n', '    function () payable public {\n', '        require((msg.value > 0) && (_receiveEth));\n', '        uint256 _tokens = mul(div(msg.value, 1 ether),_tokePerEth);\n', '        require(_totalSupply >= _tokens);//, "Insufficient tokens available at current exchange rate");\n', '        _totalSupply = sub(_totalSupply, _tokens);\n', '        balances[msg.sender] = add(balances[msg.sender], _tokens);\n', '        Transfer(this, msg.sender, _tokens);\n', '        _lifeVal = add(_lifeVal, msg.value);\n', '\n', '        if(_feesEnabled) {\n', '            if(!_payFees) {\n', '                // then check whether fees are due and set _payFees accordingly\n', '                if(_lifeVal >= _feeLimit) _payFees = true;\n', '            }\n', '\n', '            if(_payFees) {\n', '                _devFees = add(_devFees, ((msg.value * _fees) / 10000));\n', '            }\n', '        }\n', '    }\n', '\n', '    function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){\n', '        Partner p = Partner(_targetContract);\n', '        p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);\n', '        return true;\n', '    }\n', '\n', '    function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens) {\n', '        require(exchangeRates[msg.sender] > 0);\n', '\n', '        uint256 _exchanged = mul(_RequestedTokens, exchangeRates[_source]);\n', '\n', '        require(_exchanged <= _totalSupply);\n', '\n', '        balances[_recipient] = add(balances[_recipient],_exchanged);\n', '        _totalSupply = sub(_totalSupply, _exchanged);\n', '        Exchanged(_source, _recipient, _exchanged);\n', '        Transfer(this, _recipient, _exchanged);\n', '    }\n', '\n', '    function changePayRate(uint256 _newRate) public {\n', '        require(((msg.sender == _owner) || (msg.sender == _dev)) && (_newRate >= 0));\n', '        _tokePerEth = _newRate;\n', '    }\n', '\n', '    function safeWithdrawal(address _receiver, uint256 _value) public {\n', '        require((msg.sender == _owner));\n', '        uint256 valueAsEth = mul(_value,1 ether);\n', '\n', '        // if fees are enabled send the dev fees\n', '        if(_feesEnabled) {\n', '            if(_payFees) _devFeesAddr.transfer(_devFees);\n', '            _devFees = 0;\n', '        }\n', '\n', '        // check balance before transferring\n', '        require(valueAsEth <= this.balance);\n', '        _receiver.transfer(valueAsEth);\n', '    }\n', '\n', '    function balanceOf(address _receiver) public constant returns (uint balance) {\n', '        return balances[_receiver];\n', '    }\n', '\n', '    function changeOwner(address _receiver) public {\n', '        require(msg.sender == _owner);\n', '        _dev = _receiver;\n', '    }\n', '\n', '    function changeDev(address _receiver) public {\n', '        require(msg.sender == _dev);\n', '        _owner = _receiver;\n', '    }\n', '\n', '    function changeDevFeesAddr(address _receiver) public {\n', '        require(msg.sender == _dev);\n', '        _devFeesAddr = _receiver;\n', '    }\n', '\n', '    function toggleReceiveEth() public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        if(!_receiveEth) {\n', '            _receiveEth = true;\n', '        }\n', '        else {\n', '            _receiveEth = false;\n', '        }\n', '    }\n', '\n', '    function toggleFreezeTokensFlag() public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        if(!_coldStorage) {\n', '            _coldStorage = true;\n', '        }\n', '        else {\n', '            _coldStorage = false;\n', '        }\n', '    }\n', '\n', '    function defrostFrozenTokens() public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        _totalSupply = add(_totalSupply, _frozenTokens);\n', '        _frozenTokens = 0;\n', '    }\n', '\n', '    function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        uint codeLength;\n', '        assembly {\n', '            codeLength := extcodesize(_partner)\n', '        }\n', '        require(codeLength > 0);\n', '        exchangeRates[_partner] = _rate;\n', '    }\n', '\n', '    function addExchangePartnerTargetAddress(address _partner) public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        exchangePartners[_partner] = true;\n', '    }\n', '\n', '    function removeExchangePartnerTargetAddress(address _partner) public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        exchangePartners[_partner] = false;\n', '    }\n', '\n', '    function canExchange(address _targetContract) public constant returns (bool) {\n', '        return exchangePartners[_targetContract];\n', '    }\n', '\n', '    function contractExchangeRate(address _exchangingContract) public constant returns (uint256) {\n', '        return exchangeRates[_exchangingContract];\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // just in case fallback\n', '    function updateTokenBalance(uint256 newBalance) public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        _totalSupply = newBalance;\n', '    }\n', '\n', '    function getBalance() public constant returns (uint256) {\n', '        return this.balance;\n', '    }\n', '\n', '    function getLifeVal() public returns (uint256) {\n', '        require((msg.sender == _owner) || (msg.sender == _dev));\n', '        return _lifeVal;\n', '    }\n', '\n', '    function payFeesToggle() {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        if(_payFees) {\n', '            _payFees = false;\n', '        }\n', '        else {\n', '            _payFees = true;\n', '        }\n', '    }\n', '\n', '    // enables fee update - must be between 0 and 100 (%)\n', '    function updateFeeAmount(uint _newFee) public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        require((_newFee >= 0) && (_newFee <= 100));\n', '        _fees = _newFee * 100;\n', '    }\n', '\n', '    function withdrawDevFees() public {\n', '        require(_payFees);\n', '        _devFeesAddr.transfer(_devFees);\n', '        _devFees = 0;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}']
['contract Partner {\n', '    function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);\n', '}\n', '\n', 'contract COE {\n', '\n', '    string public name = "CoEval";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "COE";\n', '\n', '\n', '    address public _owner;\n', '    address public _dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;\n', '    address _pMine = 0x76D05E325973D7693Bb854ED258431aC7DBBeDc3;\n', '    address public _devFeesAddr;\n', '    uint256 public _tokePerEth = 177000000000000000;\n', '    bool public _coldStorage = true;\n', '    bool public _receiveEth = true;\n', '\n', '    // fees vars - added for future extensibility purposes only\n', '    bool _feesEnabled = false;\n', '    bool _payFees = false;\n', '    uint256 _fees;  // the calculation expects % * 100 (so 10% is 1000)\n', '    uint256 _lifeVal = 0;\n', '    uint256 _feeLimit = 0;\n', '    uint256 _devFees = 0;\n', '\n', '    uint256 public _totalSupply = 100000 * 1 ether;\n', '    uint256 public _frozenTokens = 0;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Exchanged(address indexed _from, address indexed _to, uint _value);\n', '    // Storage\n', '    mapping (address => uint256) public balances;\n', '\n', '    // list of contract addresses that can request tokens\n', '    // use add/remove functions to update\n', '    mapping (address => bool) public exchangePartners;\n', '\n', '    // permitted exch partners and associated token rates\n', '    // rate is X target tokens per Y incoming so newTokens = Tokens/Rate\n', '    mapping (address => uint256) public exchangeRates;\n', '\n', '    function MNY() {\n', '        _owner = msg.sender;\n', '        preMine();\n', '    }\n', '\n', '    function preMine() internal {\n', '        balances[_dev] = 32664750000000000000000;\n', '        Transfer(this, _pMine, 32664750000000000000000);\n', '        _totalSupply = sub(_totalSupply, 32664750000000000000000);\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public {\n', '        // sender must have enough tokens to transfer\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        if(_to == address(this)) {\n', '            // WARNING: if you transfer tokens back to the contract you will lose them\n', '            // use the exchange function to exchange with approved partner contracts\n', '            _totalSupply = add(_totalSupply, _value);\n', '            balances[msg.sender] = sub(balanceOf(msg.sender), _value);\n', '            Transfer(msg.sender, _to, _value);\n', '        }\n', '        else {\n', '            uint codeLength;\n', '\n', '            assembly {\n', '                codeLength := extcodesize(_to)\n', '            }\n', '\n', "            // we decided that we don't want to lose tokens into OTHER contracts that aren't exchange partners\n", '            require(codeLength == 0);\n', '\n', '            balances[msg.sender] = sub(balanceOf(msg.sender), _value);\n', '            balances[_to] = add(balances[_to], _value);\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public {\n', '        /// sender must have enough tokens to transfer\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        if(_to == address(this)) {\n', '            // WARNING: if you transfer tokens back to the contract you will lose them\n', '            // use the exchange function to exchange for tokens with approved partner contracts\n', '            _totalSupply = add(_totalSupply, _value);\n', '            balances[msg.sender] = sub(balanceOf(msg.sender), _value);\n', '            Transfer(msg.sender, _to, _value);\n', '        }\n', '        else {\n', '            uint codeLength;\n', '\n', '            assembly {\n', '                codeLength := extcodesize(_to)\n', '            }\n', '\n', "            // we decided that we don't want to lose tokens into OTHER contracts that aren't exchange partners\n", '            require(codeLength == 0);\n', '\n', '            balances[msg.sender] = sub(balanceOf(msg.sender), _value);\n', '            balances[_to] = add(balances[_to], _value);\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '        }\n', '    }\n', '\n', '    function exchange(address _partner, uint _amount) public {\n', '        require(balances[msg.sender] >= _amount);\n', '\n', '        // intended partner addy must be a contract\n', '        uint codeLength;\n', '        assembly {\n', '        // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_partner)\n', '        }\n', '        require(codeLength > 0);\n', '\n', '        require(exchangePartners[_partner]);\n', '        require(requestTokensFromOtherContract(_partner, this, msg.sender, _amount));\n', '\n', '        if(_coldStorage) {\n', '            // put the tokens from this contract into cold storage if we need to\n', '            // (NB: if these are in reality to be burnt, we just never defrost them)\n', '            _frozenTokens = add(_frozenTokens, _amount);\n', '        }\n', '        else {\n', '            // or return them to the available supply if not\n', '            _totalSupply = add(_totalSupply, _amount);\n', '        }\n', '\n', '        balances[msg.sender] = sub(balanceOf(msg.sender), _amount);\n', '        Exchanged(msg.sender, _partner, _amount);\n', '        Transfer(msg.sender, this, _amount);\n', '    }\n', '\n', '    // fallback to receive ETH into contract and send tokens back based on current exchange rate\n', '    function () payable public {\n', '        require((msg.value > 0) && (_receiveEth));\n', '        uint256 _tokens = mul(div(msg.value, 1 ether),_tokePerEth);\n', '        require(_totalSupply >= _tokens);//, "Insufficient tokens available at current exchange rate");\n', '        _totalSupply = sub(_totalSupply, _tokens);\n', '        balances[msg.sender] = add(balances[msg.sender], _tokens);\n', '        Transfer(this, msg.sender, _tokens);\n', '        _lifeVal = add(_lifeVal, msg.value);\n', '\n', '        if(_feesEnabled) {\n', '            if(!_payFees) {\n', '                // then check whether fees are due and set _payFees accordingly\n', '                if(_lifeVal >= _feeLimit) _payFees = true;\n', '            }\n', '\n', '            if(_payFees) {\n', '                _devFees = add(_devFees, ((msg.value * _fees) / 10000));\n', '            }\n', '        }\n', '    }\n', '\n', '    function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){\n', '        Partner p = Partner(_targetContract);\n', '        p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);\n', '        return true;\n', '    }\n', '\n', '    function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens) {\n', '        require(exchangeRates[msg.sender] > 0);\n', '\n', '        uint256 _exchanged = mul(_RequestedTokens, exchangeRates[_source]);\n', '\n', '        require(_exchanged <= _totalSupply);\n', '\n', '        balances[_recipient] = add(balances[_recipient],_exchanged);\n', '        _totalSupply = sub(_totalSupply, _exchanged);\n', '        Exchanged(_source, _recipient, _exchanged);\n', '        Transfer(this, _recipient, _exchanged);\n', '    }\n', '\n', '    function changePayRate(uint256 _newRate) public {\n', '        require(((msg.sender == _owner) || (msg.sender == _dev)) && (_newRate >= 0));\n', '        _tokePerEth = _newRate;\n', '    }\n', '\n', '    function safeWithdrawal(address _receiver, uint256 _value) public {\n', '        require((msg.sender == _owner));\n', '        uint256 valueAsEth = mul(_value,1 ether);\n', '\n', '        // if fees are enabled send the dev fees\n', '        if(_feesEnabled) {\n', '            if(_payFees) _devFeesAddr.transfer(_devFees);\n', '            _devFees = 0;\n', '        }\n', '\n', '        // check balance before transferring\n', '        require(valueAsEth <= this.balance);\n', '        _receiver.transfer(valueAsEth);\n', '    }\n', '\n', '    function balanceOf(address _receiver) public constant returns (uint balance) {\n', '        return balances[_receiver];\n', '    }\n', '\n', '    function changeOwner(address _receiver) public {\n', '        require(msg.sender == _owner);\n', '        _dev = _receiver;\n', '    }\n', '\n', '    function changeDev(address _receiver) public {\n', '        require(msg.sender == _dev);\n', '        _owner = _receiver;\n', '    }\n', '\n', '    function changeDevFeesAddr(address _receiver) public {\n', '        require(msg.sender == _dev);\n', '        _devFeesAddr = _receiver;\n', '    }\n', '\n', '    function toggleReceiveEth() public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        if(!_receiveEth) {\n', '            _receiveEth = true;\n', '        }\n', '        else {\n', '            _receiveEth = false;\n', '        }\n', '    }\n', '\n', '    function toggleFreezeTokensFlag() public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        if(!_coldStorage) {\n', '            _coldStorage = true;\n', '        }\n', '        else {\n', '            _coldStorage = false;\n', '        }\n', '    }\n', '\n', '    function defrostFrozenTokens() public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        _totalSupply = add(_totalSupply, _frozenTokens);\n', '        _frozenTokens = 0;\n', '    }\n', '\n', '    function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        uint codeLength;\n', '        assembly {\n', '            codeLength := extcodesize(_partner)\n', '        }\n', '        require(codeLength > 0);\n', '        exchangeRates[_partner] = _rate;\n', '    }\n', '\n', '    function addExchangePartnerTargetAddress(address _partner) public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        exchangePartners[_partner] = true;\n', '    }\n', '\n', '    function removeExchangePartnerTargetAddress(address _partner) public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        exchangePartners[_partner] = false;\n', '    }\n', '\n', '    function canExchange(address _targetContract) public constant returns (bool) {\n', '        return exchangePartners[_targetContract];\n', '    }\n', '\n', '    function contractExchangeRate(address _exchangingContract) public constant returns (uint256) {\n', '        return exchangeRates[_exchangingContract];\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // just in case fallback\n', '    function updateTokenBalance(uint256 newBalance) public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        _totalSupply = newBalance;\n', '    }\n', '\n', '    function getBalance() public constant returns (uint256) {\n', '        return this.balance;\n', '    }\n', '\n', '    function getLifeVal() public returns (uint256) {\n', '        require((msg.sender == _owner) || (msg.sender == _dev));\n', '        return _lifeVal;\n', '    }\n', '\n', '    function payFeesToggle() {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        if(_payFees) {\n', '            _payFees = false;\n', '        }\n', '        else {\n', '            _payFees = true;\n', '        }\n', '    }\n', '\n', '    // enables fee update - must be between 0 and 100 (%)\n', '    function updateFeeAmount(uint _newFee) public {\n', '        require((msg.sender == _dev) || (msg.sender == _owner));\n', '        require((_newFee >= 0) && (_newFee <= 100));\n', '        _fees = _newFee * 100;\n', '    }\n', '\n', '    function withdrawDevFees() public {\n', '        require(_payFees);\n', '        _devFeesAddr.transfer(_devFees);\n', '        _devFees = 0;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}']
