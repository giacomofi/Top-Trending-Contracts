['pragma solidity 0.4.21;\n', '/*\n', ' This issue is covered by\n', 'INTERNATIONAL BILL OF EXCHANGE (IBOE), REGISTRATION NUMBER: 99-279-0080 and SERIAL\n', 'NUMBER: 092014 PARTIAL ASSIGNMENT /\n', 'RELEASE IN THE AMOUNT OF $ 500,000,000,000.00 USD in words;\n', 'FIVE HUNDRED BILLION and No / I00 USD, submitted to and in accordance with FINAL ARTICLES OF\n', '(UNICITRAL Convention 1988) ratified Articles 1-7, 11-13.46-3, 47-4 (c), 51, House Joint Resolution 192 of June 5.1933,\n', 'UCC 1-104, 10-104. Reserved RELASED BY SECRETARY OF THE TRESAURY OF THE UNITED STATES OF AMERICA\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply()public view returns(uint total_Supply);\n', '    function balanceOf(address who)public view returns(uint256);\n', '    function allowance(address owner, address spender)public view returns(uint);\n', '    function transferFrom(address from, address to, uint value)public returns(bool ok);\n', '    function approve(address spender, uint value)public returns(bool ok);\n', '    function transfer(address to, uint value)public returns(bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract FENIX is ERC20\n', '{\n', '    using SafeMath for uint256;\n', '        // Name of the token\n', '    string public constant name = "FENIX";\n', '\n', '    // Symbol of token\n', '    string public constant symbol = "FNX";\n', '    uint8 public constant decimals = 18;\n', '    uint public _totalsupply = 1000000000 * 10 ** 18; // 1 Billion FNX Coins\n', '    address public owner;\n', '    uint256 public _price_tokn = 100;  //1 USD in cents\n', '    uint256 no_of_tokens;\n', '    uint256 total_token;\n', '    bool stopped = false;\n', '    uint256 public ico_startdate;\n', '    uint256 public ico_enddate;\n', '    uint256 public preico_startdate;\n', '    uint256 public preico_enddate;\n', '    bool public icoRunningStatus;\n', '    bool public lockstatus; \n', '  \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    address public ethFundMain = 0xBe80a978364649422708470c979435f43e027209; // address to receive ether from smart contract\n', '    uint256 public ethreceived;\n', '    uint bonusCalculationFactor;\n', '    uint256 public pre_minContribution = 100000;// 1000 USD in cents for pre sale\n', '    uint256 ContributionAmount;\n', ' \n', ' \n', '    uint public priceFactor;\n', '    mapping(address => uint256) availTokens;\n', '\n', '    enum Stages {\n', '        NOTSTARTED,\n', '        PREICO,\n', '        ICO,\n', '        ENDED\n', '    }\n', '    Stages public stage;\n', '\n', '    modifier atStage(Stages _stage) {\n', '        require (stage == _stage);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner(){\n', '        require (msg.sender == owner);\n', '     _;\n', '    }\n', '\n', '  \n', '    function FENIX(uint256 EtherPriceFactor) public\n', '    {\n', '        require(EtherPriceFactor != 0);\n', '        owner = msg.sender;\n', '        balances[owner] = 890000000 * 10 ** 18;  // 890 Million given to owner\n', '        stage = Stages.NOTSTARTED;\n', '        icoRunningStatus =true;\n', '        lockstatus = true;\n', '        priceFactor = EtherPriceFactor;\n', '        emit Transfer(0, owner, balances[owner]);\n', '    }\n', '\n', '    function () public payable\n', '    {\n', '        require(stage != Stages.ENDED);\n', '        require(!stopped && msg.sender != owner);\n', '        if (stage == Stages.PREICO && now <= preico_enddate){\n', '             require((msg.value).mul(priceFactor.mul(100)) >= (pre_minContribution.mul(10 ** 18)));\n', '\n', '          y();\n', '\n', '    }\n', '    else  if (stage == Stages.ICO && now <= ico_enddate){\n', '  \n', '          _price_tokn= getCurrentTokenPrice();\n', '       \n', '          y();\n', '\n', '    }\n', '    else {\n', '        revert();\n', '    }\n', '    }\n', '    \n', '   \n', '\n', '  function getCurrentTokenPrice() private returns (uint)\n', '        {\n', '        uint price_tokn;\n', '        bonusCalculationFactor = (block.timestamp.sub(ico_startdate)).div(3600); //time period in seconds\n', '        if (bonusCalculationFactor== 0) \n', '            price_tokn = 65;                     //35 % Discount\n', '        else if (bonusCalculationFactor >= 1 && bonusCalculationFactor < 24) \n', '            price_tokn = 70;                     //30 % Discount\n', '        else if (bonusCalculationFactor >= 24 && bonusCalculationFactor < 168) \n', '            price_tokn = 80;                      //20 % Discount\n', '        else if (bonusCalculationFactor >= 168 && bonusCalculationFactor < 336) \n', '            price_tokn = 90;                     //10 % Discount\n', '        else if (bonusCalculationFactor >= 336) \n', '            price_tokn = 100;                  //0 % Discount\n', '            \n', '            return price_tokn;\n', '     \n', '        }\n', '        \n', '         function y() private {\n', '            \n', '             no_of_tokens = ((msg.value).mul(priceFactor.mul(100))).div(_price_tokn);\n', '             if(_price_tokn >=80){\n', '                 availTokens[msg.sender] = availTokens[msg.sender].add(no_of_tokens);\n', '             }\n', '             ethreceived = ethreceived.add(msg.value);\n', '             balances[address(this)] = (balances[address(this)]).sub(no_of_tokens);\n', '             balances[msg.sender] = balances[msg.sender].add(no_of_tokens);\n', '             emit  Transfer(address(this), msg.sender, no_of_tokens);\n', '    }\n', '\n', '   \n', '    // called by the owner, pause ICO\n', '    function StopICO() external onlyOwner  {\n', '        stopped = true;\n', '\n', '    }\n', '\n', '    // called by the owner , resumes ICO\n', '    function releaseICO() external onlyOwner\n', '    {\n', '        stopped = false;\n', '\n', '    }\n', '    \n', '    // to change price of Ether in USD, in case price increases or decreases\n', '     function setpricefactor(uint256 newPricefactor) external onlyOwner\n', '    {\n', '        priceFactor = newPricefactor;\n', '        \n', '    }\n', '    \n', '     function setEthmainAddress(address newEthfundaddress) external onlyOwner\n', '    {\n', '        ethFundMain = newEthfundaddress;\n', '    }\n', '    \n', '     function start_PREICO() external onlyOwner atStage(Stages.NOTSTARTED)\n', '      {\n', '          stage = Stages.PREICO;\n', '          stopped = false;\n', '          _price_tokn = 60;     //40 % dicount\n', '          balances[address(this)] =10000000 * 10 ** 18 ; //10 million in preICO\n', '         preico_startdate = now;\n', '         preico_enddate = now + 7 days; //time for preICO\n', '       emit Transfer(0, address(this), balances[address(this)]);\n', '          }\n', '    \n', '    function start_ICO() external onlyOwner atStage(Stages.PREICO)\n', '      {\n', '          stage = Stages.ICO;\n', '          stopped = false;\n', '          balances[address(this)] =balances[address(this)].add(100000000 * 10 ** 18); //100 million in ICO\n', '         ico_startdate = now;\n', '         ico_enddate = now + 21 days; //time for ICO\n', '       emit Transfer(0, address(this), 100000000 * 10 ** 18);\n', '          }\n', '\n', '    function end_ICO() external onlyOwner atStage(Stages.ICO)\n', '    {\n', '        require(now > ico_enddate);\n', '        stage = Stages.ENDED;\n', '        icoRunningStatus = false;\n', '        uint256 x = balances[address(this)];\n', '        balances[owner] = (balances[owner]).add( balances[address(this)]);\n', '        balances[address(this)] = 0;\n', '       emit  Transfer(address(this), owner , x);\n', '        \n', '    }\n', '    \n', '    // This function can be used by owner in emergency to update running status parameter\n', '    function fixSpecications(bool RunningStatusICO) external onlyOwner\n', '    {\n', '        icoRunningStatus = RunningStatusICO;\n', '    }\n', '    \n', '    // function to remove locking period after 12 months, can be called only be owner\n', '    function removeLocking(bool RunningStatusLock) external onlyOwner\n', '    {\n', '        lockstatus = RunningStatusLock;\n', '    }\n', '\n', '\n', '   function balanceDetails(address investor)\n', '        constant\n', '        public\n', '        returns (uint256,uint256)\n', '    {\n', '        return (availTokens[investor], balances[investor]) ;\n', '    }\n', '    \n', '    // what is the total supply of the ech tokens\n', '    function totalSupply() public view returns(uint256 total_Supply) {\n', '        total_Supply = _totalsupply;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner)public view returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(address _from, address _to, uint256 _amount)public returns(bool success) {\n', '        require(_to != 0x0);\n', '        require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);\n', '        balances[_from] = (balances[_from]).sub(_amount);\n', '        allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount)public returns(bool success) {\n', '        require(_spender != 0x0);\n', '        if (!icoRunningStatus && lockstatus) {\n', '            require(_amount <= availTokens[msg.sender]);\n', '        }\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)public view returns(uint256 remaining) {\n', '        require(_owner != 0x0 && _spender != 0x0);\n', '        return allowed[_owner][_spender];\n', '    }\n', '    // Transfer the balance from owner&#39;s account to another account\n', '    function transfer(address _to, uint256 _amount) public returns(bool success) {\n', '       \n', '       if ( msg.sender == owner) {\n', '            require(balances[owner] >= _amount && _amount >= 0);\n', '            balances[owner] = balances[owner].sub(_amount);\n', '            balances[_to] += _amount;\n', '            availTokens[_to] += _amount;\n', '            emit Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        }\n', '        else\n', '        if (!icoRunningStatus && lockstatus && msg.sender != owner) {\n', '            require(availTokens[msg.sender] >= _amount);\n', '            availTokens[msg.sender] -= _amount;\n', '            balances[msg.sender] -= _amount;\n', '            availTokens[_to] += _amount;\n', '            balances[_to] += _amount;\n', '            emit Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        }\n', '\n', '          else if(!lockstatus)\n', '         {\n', '           require(balances[msg.sender] >= _amount && _amount >= 0);\n', '           balances[msg.sender] = (balances[msg.sender]).sub(_amount);\n', '           balances[_to] = (balances[_to]).add(_amount);\n', '           emit Transfer(msg.sender, _to, _amount);\n', '           return true;\n', '          }\n', '\n', '        else{\n', '            revert();\n', '        }\n', '    }\n', '\n', '\n', '    //In case the ownership needs to be transferred\n', '\tfunction transferOwnership(address newOwner)public onlyOwner\n', '\t{\n', '\t    require( newOwner != 0x0);\n', '\t    balances[newOwner] = (balances[newOwner]).add(balances[owner]);\n', '\t    balances[owner] = 0;\n', '\t    owner = newOwner;\n', '\t    emit Transfer(msg.sender, newOwner, balances[newOwner]);\n', '\t}\n', '\n', '\n', '    function drain() external onlyOwner {\n', '        address myAddress = this;\n', '        ethFundMain.transfer(myAddress.balance);\n', '    }\n', '\n', '}']
['pragma solidity 0.4.21;\n', '/*\n', ' This issue is covered by\n', 'INTERNATIONAL BILL OF EXCHANGE (IBOE), REGISTRATION NUMBER: 99-279-0080 and SERIAL\n', 'NUMBER: 092014 PARTIAL ASSIGNMENT /\n', 'RELEASE IN THE AMOUNT OF $ 500,000,000,000.00 USD in words;\n', 'FIVE HUNDRED BILLION and No / I00 USD, submitted to and in accordance with FINAL ARTICLES OF\n', '(UNICITRAL Convention 1988) ratified Articles 1-7, 11-13.46-3, 47-4 (c), 51, House Joint Resolution 192 of June 5.1933,\n', 'UCC 1-104, 10-104. Reserved RELASED BY SECRETARY OF THE TRESAURY OF THE UNITED STATES OF AMERICA\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply()public view returns(uint total_Supply);\n', '    function balanceOf(address who)public view returns(uint256);\n', '    function allowance(address owner, address spender)public view returns(uint);\n', '    function transferFrom(address from, address to, uint value)public returns(bool ok);\n', '    function approve(address spender, uint value)public returns(bool ok);\n', '    function transfer(address to, uint value)public returns(bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract FENIX is ERC20\n', '{\n', '    using SafeMath for uint256;\n', '        // Name of the token\n', '    string public constant name = "FENIX";\n', '\n', '    // Symbol of token\n', '    string public constant symbol = "FNX";\n', '    uint8 public constant decimals = 18;\n', '    uint public _totalsupply = 1000000000 * 10 ** 18; // 1 Billion FNX Coins\n', '    address public owner;\n', '    uint256 public _price_tokn = 100;  //1 USD in cents\n', '    uint256 no_of_tokens;\n', '    uint256 total_token;\n', '    bool stopped = false;\n', '    uint256 public ico_startdate;\n', '    uint256 public ico_enddate;\n', '    uint256 public preico_startdate;\n', '    uint256 public preico_enddate;\n', '    bool public icoRunningStatus;\n', '    bool public lockstatus; \n', '  \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    address public ethFundMain = 0xBe80a978364649422708470c979435f43e027209; // address to receive ether from smart contract\n', '    uint256 public ethreceived;\n', '    uint bonusCalculationFactor;\n', '    uint256 public pre_minContribution = 100000;// 1000 USD in cents for pre sale\n', '    uint256 ContributionAmount;\n', ' \n', ' \n', '    uint public priceFactor;\n', '    mapping(address => uint256) availTokens;\n', '\n', '    enum Stages {\n', '        NOTSTARTED,\n', '        PREICO,\n', '        ICO,\n', '        ENDED\n', '    }\n', '    Stages public stage;\n', '\n', '    modifier atStage(Stages _stage) {\n', '        require (stage == _stage);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner(){\n', '        require (msg.sender == owner);\n', '     _;\n', '    }\n', '\n', '  \n', '    function FENIX(uint256 EtherPriceFactor) public\n', '    {\n', '        require(EtherPriceFactor != 0);\n', '        owner = msg.sender;\n', '        balances[owner] = 890000000 * 10 ** 18;  // 890 Million given to owner\n', '        stage = Stages.NOTSTARTED;\n', '        icoRunningStatus =true;\n', '        lockstatus = true;\n', '        priceFactor = EtherPriceFactor;\n', '        emit Transfer(0, owner, balances[owner]);\n', '    }\n', '\n', '    function () public payable\n', '    {\n', '        require(stage != Stages.ENDED);\n', '        require(!stopped && msg.sender != owner);\n', '        if (stage == Stages.PREICO && now <= preico_enddate){\n', '             require((msg.value).mul(priceFactor.mul(100)) >= (pre_minContribution.mul(10 ** 18)));\n', '\n', '          y();\n', '\n', '    }\n', '    else  if (stage == Stages.ICO && now <= ico_enddate){\n', '  \n', '          _price_tokn= getCurrentTokenPrice();\n', '       \n', '          y();\n', '\n', '    }\n', '    else {\n', '        revert();\n', '    }\n', '    }\n', '    \n', '   \n', '\n', '  function getCurrentTokenPrice() private returns (uint)\n', '        {\n', '        uint price_tokn;\n', '        bonusCalculationFactor = (block.timestamp.sub(ico_startdate)).div(3600); //time period in seconds\n', '        if (bonusCalculationFactor== 0) \n', '            price_tokn = 65;                     //35 % Discount\n', '        else if (bonusCalculationFactor >= 1 && bonusCalculationFactor < 24) \n', '            price_tokn = 70;                     //30 % Discount\n', '        else if (bonusCalculationFactor >= 24 && bonusCalculationFactor < 168) \n', '            price_tokn = 80;                      //20 % Discount\n', '        else if (bonusCalculationFactor >= 168 && bonusCalculationFactor < 336) \n', '            price_tokn = 90;                     //10 % Discount\n', '        else if (bonusCalculationFactor >= 336) \n', '            price_tokn = 100;                  //0 % Discount\n', '            \n', '            return price_tokn;\n', '     \n', '        }\n', '        \n', '         function y() private {\n', '            \n', '             no_of_tokens = ((msg.value).mul(priceFactor.mul(100))).div(_price_tokn);\n', '             if(_price_tokn >=80){\n', '                 availTokens[msg.sender] = availTokens[msg.sender].add(no_of_tokens);\n', '             }\n', '             ethreceived = ethreceived.add(msg.value);\n', '             balances[address(this)] = (balances[address(this)]).sub(no_of_tokens);\n', '             balances[msg.sender] = balances[msg.sender].add(no_of_tokens);\n', '             emit  Transfer(address(this), msg.sender, no_of_tokens);\n', '    }\n', '\n', '   \n', '    // called by the owner, pause ICO\n', '    function StopICO() external onlyOwner  {\n', '        stopped = true;\n', '\n', '    }\n', '\n', '    // called by the owner , resumes ICO\n', '    function releaseICO() external onlyOwner\n', '    {\n', '        stopped = false;\n', '\n', '    }\n', '    \n', '    // to change price of Ether in USD, in case price increases or decreases\n', '     function setpricefactor(uint256 newPricefactor) external onlyOwner\n', '    {\n', '        priceFactor = newPricefactor;\n', '        \n', '    }\n', '    \n', '     function setEthmainAddress(address newEthfundaddress) external onlyOwner\n', '    {\n', '        ethFundMain = newEthfundaddress;\n', '    }\n', '    \n', '     function start_PREICO() external onlyOwner atStage(Stages.NOTSTARTED)\n', '      {\n', '          stage = Stages.PREICO;\n', '          stopped = false;\n', '          _price_tokn = 60;     //40 % dicount\n', '          balances[address(this)] =10000000 * 10 ** 18 ; //10 million in preICO\n', '         preico_startdate = now;\n', '         preico_enddate = now + 7 days; //time for preICO\n', '       emit Transfer(0, address(this), balances[address(this)]);\n', '          }\n', '    \n', '    function start_ICO() external onlyOwner atStage(Stages.PREICO)\n', '      {\n', '          stage = Stages.ICO;\n', '          stopped = false;\n', '          balances[address(this)] =balances[address(this)].add(100000000 * 10 ** 18); //100 million in ICO\n', '         ico_startdate = now;\n', '         ico_enddate = now + 21 days; //time for ICO\n', '       emit Transfer(0, address(this), 100000000 * 10 ** 18);\n', '          }\n', '\n', '    function end_ICO() external onlyOwner atStage(Stages.ICO)\n', '    {\n', '        require(now > ico_enddate);\n', '        stage = Stages.ENDED;\n', '        icoRunningStatus = false;\n', '        uint256 x = balances[address(this)];\n', '        balances[owner] = (balances[owner]).add( balances[address(this)]);\n', '        balances[address(this)] = 0;\n', '       emit  Transfer(address(this), owner , x);\n', '        \n', '    }\n', '    \n', '    // This function can be used by owner in emergency to update running status parameter\n', '    function fixSpecications(bool RunningStatusICO) external onlyOwner\n', '    {\n', '        icoRunningStatus = RunningStatusICO;\n', '    }\n', '    \n', '    // function to remove locking period after 12 months, can be called only be owner\n', '    function removeLocking(bool RunningStatusLock) external onlyOwner\n', '    {\n', '        lockstatus = RunningStatusLock;\n', '    }\n', '\n', '\n', '   function balanceDetails(address investor)\n', '        constant\n', '        public\n', '        returns (uint256,uint256)\n', '    {\n', '        return (availTokens[investor], balances[investor]) ;\n', '    }\n', '    \n', '    // what is the total supply of the ech tokens\n', '    function totalSupply() public view returns(uint256 total_Supply) {\n', '        total_Supply = _totalsupply;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner)public view returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(address _from, address _to, uint256 _amount)public returns(bool success) {\n', '        require(_to != 0x0);\n', '        require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);\n', '        balances[_from] = (balances[_from]).sub(_amount);\n', '        allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount)public returns(bool success) {\n', '        require(_spender != 0x0);\n', '        if (!icoRunningStatus && lockstatus) {\n', '            require(_amount <= availTokens[msg.sender]);\n', '        }\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)public view returns(uint256 remaining) {\n', '        require(_owner != 0x0 && _spender != 0x0);\n', '        return allowed[_owner][_spender];\n', '    }\n', "    // Transfer the balance from owner's account to another account\n", '    function transfer(address _to, uint256 _amount) public returns(bool success) {\n', '       \n', '       if ( msg.sender == owner) {\n', '            require(balances[owner] >= _amount && _amount >= 0);\n', '            balances[owner] = balances[owner].sub(_amount);\n', '            balances[_to] += _amount;\n', '            availTokens[_to] += _amount;\n', '            emit Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        }\n', '        else\n', '        if (!icoRunningStatus && lockstatus && msg.sender != owner) {\n', '            require(availTokens[msg.sender] >= _amount);\n', '            availTokens[msg.sender] -= _amount;\n', '            balances[msg.sender] -= _amount;\n', '            availTokens[_to] += _amount;\n', '            balances[_to] += _amount;\n', '            emit Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        }\n', '\n', '          else if(!lockstatus)\n', '         {\n', '           require(balances[msg.sender] >= _amount && _amount >= 0);\n', '           balances[msg.sender] = (balances[msg.sender]).sub(_amount);\n', '           balances[_to] = (balances[_to]).add(_amount);\n', '           emit Transfer(msg.sender, _to, _amount);\n', '           return true;\n', '          }\n', '\n', '        else{\n', '            revert();\n', '        }\n', '    }\n', '\n', '\n', '    //In case the ownership needs to be transferred\n', '\tfunction transferOwnership(address newOwner)public onlyOwner\n', '\t{\n', '\t    require( newOwner != 0x0);\n', '\t    balances[newOwner] = (balances[newOwner]).add(balances[owner]);\n', '\t    balances[owner] = 0;\n', '\t    owner = newOwner;\n', '\t    emit Transfer(msg.sender, newOwner, balances[newOwner]);\n', '\t}\n', '\n', '\n', '    function drain() external onlyOwner {\n', '        address myAddress = this;\n', '        ethFundMain.transfer(myAddress.balance);\n', '    }\n', '\n', '}']
