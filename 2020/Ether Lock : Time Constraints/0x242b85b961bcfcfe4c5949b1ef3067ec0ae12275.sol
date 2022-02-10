['pragma solidity ^0.7.4;\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', 'contract CryptillionClub {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    struct User {\n', '        address sponsor;\n', '        bool[21] relations;\n', '        uint[21] levels;\n', '    }\n', '    \n', '    \n', '    mapping (address => User) private users;\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    \n', '    \n', '    address private owner;\n', '    address private founder;\n', '\n', '    uint private usersCounter;\n', '    uint private normalLevelPrice;\n', '    uint private levelTime;\n', '    \n', '    uint private discountCounter;\n', '    uint private discountTimer;\n', '    uint private discountFactor;\n', '    bool private discountFirst;\n', '\n', '    uint private _totalSupply;\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '\n', '    event GotPartner(address indexed user, address indexed sponsor, uint indexed level, uint regDate);\n', '    event LostPartner(address indexed user, address indexed sponsor, uint indexed level, uint regDate);\n', '    event GotProfit(address indexed sponsor, address indexed user, uint etherAmount, uint tokenAmount, uint rate, uint level, uint date);\n', '    event LostProfit(address indexed sponsor, address indexed user, uint etherAmount, uint tokenAmount, uint rate, uint level, uint date);\n', '    \n', '    event TokenRateChanged(uint indexed tokenRate, uint indexed date);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Sell(address indexed seller, uint256 tokenAmount, uint256 rate, uint256 etherAmount, uint256 date);\n', '\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '        founder = msg.sender;\n', '\n', '        usersCounter = 0;\n', '\n', '        normalLevelPrice = 100000000000000000;\n', '        levelTime = 8640000;\n', '        \n', '        _name = "Cryptillion Club Token";\n', '        _symbol = "CRION";\n', '        _decimals = 18;\n', '        \n', '        emit TokenRateChanged(10000000000000000, block.timestamp);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', "        require (_msgSender() == owner, 'Only for owner');\n", '        _;\n', '    }\n', '    \n', '    modifier maxLevel(uint _level) {\n', "        require (_level >= 1 && _level <= 20, 'Min and max levels are 1-20');\n", '        _;\n', '    }\n', '\n', '\n', '    receive() external payable {\n', '        revert();\n', '    }\n', '\n', '    function changeOwnerAddress(address _newOwner) external onlyOwner {\n', '        owner = _newOwner;\n', '        assert(owner == _newOwner);\n', '    }\n', '    \n', '    function changeFounderAddress(address _newFounder) external onlyOwner {\n', '        founder = _newFounder;\n', '        assert(founder == _newFounder);\n', '    }\n', '    \n', '    function changeNormalLevelPrice(uint _newPrice) external onlyOwner {\n', '        normalLevelPrice = _newPrice;\n', '        assert(normalLevelPrice == _newPrice);\n', '    }\n', '    \n', '    function changeLevelTime(uint _newTime) external onlyOwner {\n', '        levelTime = _newTime;\n', '        assert(levelTime == _newTime);\n', '    }\n', '    \n', '    function createDiscount(uint _counter, uint _timer, uint _factor, bool _first) external onlyOwner {\n', '        discountCounter = _counter;\n', '        discountTimer = _timer;\n', '        discountFactor = _factor;\n', '        discountFirst = _first;\n', '    }\n', '    \n', '    function registerUser(address _sponsor) external payable {\n', '        \n', "        require (msg.value == levelPrice(1), 'Wrong registration payment amount.');\n", "        require (_sponsor != address(0) && users[_sponsor].levels[0] > 0, 'Please provide registered sponsor.');\n", "        require (_sponsor != _msgSender(), 'You can\\'t be your own sponsor.');\n", "        require (users[_msgSender()].levels[0] == 0, 'You are already registered');\n", '        \n', '        address temp_sponsor = _sponsor;\n', '        uint[21] memory tempLevels;\n', '        bool[21] memory tempRelations;\n', '        \n', '        tempLevels[0] = 1;\n', '        tempRelations[0] = true;\n', '        \n', '        uint date = block.timestamp;\n', '        \n', '        for (uint i = 1; i <= 20 && temp_sponsor != address(0); ++i) {\n', '            \n', '            if(users[temp_sponsor].levels[i] >= date) {\n', '                \n', '                tempRelations[i] = true;\n', '                emit GotPartner(_msgSender(), temp_sponsor, i, date);\n', '                \n', '            } else {\n', '                \n', '                emit LostPartner(_msgSender(), temp_sponsor, i, date);\n', '            }\n', '            temp_sponsor = users[temp_sponsor].sponsor;\n', '        }\n', '        \n', '        users[_msgSender()] = User(_sponsor, tempRelations, tempLevels);\n', '        \n', '        buyLevel(1);\n', '        \n', '        ++usersCounter;\n', '    }\n', '    \n', '    function createSuperUser(address _superUser, address _sponsor) external onlyOwner {\n', '        \n', '        bool[21] memory tempRelations;\n', '        uint[21] memory tempLevels;\n', '        \n', '        tempLevels[0] = 1;\n', '        tempRelations[0] = true;\n', '\n', '        for (uint i = 1; i < 21; ++i) {\n', '            tempLevels[i] = 11044857601;\n', '        }\n', '        \n', '        users[_superUser] = User(_sponsor, tempRelations, tempLevels);\n', '        ++usersCounter;\n', '        \n', '        emit GotPartner(_superUser, _sponsor, 1, block.timestamp);\n', '    }\n', '    \n', '    function buyLevel (uint _level) public payable maxLevel(_level) {\n', '        \n', "        require(msg.value == levelPrice(_level), 'Wrong amount.');\n", "        require(users[_msgSender()].levels[0] == 1, 'Please register.');\n", '\n', '        uint nowStamp = block.timestamp;\n', '        \n', "        require(users[_msgSender()].levels[_level] < nowStamp.add(_levelTime()), 'No more than +200 days.');\n", '        \n', '        for (uint i = 1; i < _level; ++i) {\n', "            require(users[_msgSender()].levels[i] >= nowStamp, 'Please, activate the previous levels first.');\n", '        }\n', '        \n', '        if(users[_msgSender()].levels[_level] <= nowStamp) {\n', '            users[_msgSender()].levels[_level] = nowStamp.add(_levelTime());\n', '        } else {\n', '            users[_msgSender()].levels[_level] = users[_msgSender()].levels[_level].add(_levelTime());\n', '        }\n', '        \n', '        address sponsor = getSponsor(_msgSender(), _level);\n', '        \n', '        if (sponsor != address(0)) {\n', '            \n', '            uint etherAmount = msg.value;\n', '            (uint tokenAmount, uint rate) = tokenAmountForEther(etherAmount);\n', '            \n', '            if(_level == 1) {\n', '                etherAmount = etherAmount.div(2);\n', '                tokenAmount = tokenAmount.div(2);\n', '                _mint(founder, tokenAmount);\n', '            }\n', '            \n', '            if (users[sponsor].levels[_level] >= nowStamp) {\n', '            \n', '                _mint(sponsor, tokenAmount);\n', '                emit GotProfit(sponsor, _msgSender(), etherAmount, tokenAmount, rate, _level, nowStamp);\n', '                assert(balanceOf(sponsor) >= tokenAmount);\n', '                \n', '            } else {\n', '                \n', '                emit LostProfit(sponsor, _msgSender(), etherAmount, tokenAmount, rate, _level, nowStamp);\n', '                emit TokenRateChanged(_tokenRate(0), nowStamp);\n', '            }\n', '        } else {\n', '            emit TokenRateChanged(_tokenRate(0), nowStamp);\n', '        }\n', '    }\n', '    \n', '    function getSponsor(address _user, uint _level) public view maxLevel(_level) returns (address) {\n', '        \n', '        address temp_sponsor = users[_user].sponsor;\n', '        \n', '        if (!users[_user].relations[_level]) {\n', '            return address(0);\n', '        } else {\n', '            for (uint i = 2; i <= _level; ++i) {\n', '                temp_sponsor = users[temp_sponsor].sponsor;\n', '            }\n', '            return temp_sponsor;\n', '        }\n', '        \n', '    }\n', '    \n', '    function getRelations(address _user) external view returns (bool[21] memory relations) {\n', '        return users[_user].relations;\n', '    }\n', '    \n', '    function levelPrice(uint _level) public view maxLevel(_level) returns (uint) {\n', '        if((_usersCounter() > _discountCounter() && block.timestamp > _discountTimer()) || users[_msgSender()].levels[_level] != 0) {\n', '            return _normalLevelPrice();\n', '        } else if (_discountFirst() == false || _level == 1) {\n', '            return _normalLevelPrice().div(_discountFactor());\n', '        } else {\n', '            return _normalLevelPrice();\n', '        }\n', '    }\n', '    \n', '    function userInfo(address _user) public view returns (address[21] memory _sponsors, uint[21] memory _levels) {\n', '        \n', '        address[21] memory sponsors;\n', '        bool[21] memory temp_relations = users[_user].relations;\n', '        \n', '        address temp_sponsor = users[_user].sponsor;\n', '        sponsors[0] = temp_sponsor;\n', '        \n', '        for (uint i = 1; i < 21 && temp_sponsor != address(0); ++i) {\n', '            if(temp_relations[i]) {\n', '                sponsors[i] = temp_sponsor;\n', '            }\n', '            temp_sponsor = users[temp_sponsor].sponsor;\n', '        }\n', '        \n', '        return (sponsors, users[_user].levels);\n', '    }\n', '    \n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '    \n', '    function _usersCounter() public view returns (uint) {\n', '        return usersCounter;\n', '    }\n', '    \n', '    function _normalLevelPrice() public view returns (uint) {\n', '        return normalLevelPrice;\n', '    }\n', '    \n', '    function _levelTime() public view returns (uint) {\n', '        return levelTime;\n', '    }\n', '    \n', '    function _discountCounter() public view returns (uint) {\n', '        return discountCounter;\n', '    }\n', '    \n', '    function _discountTimer() public view returns (uint) {\n', '        return discountTimer;\n', '    }\n', '    \n', '    function _discountFactor() public view returns (uint) {\n', '        return discountFactor;\n', '    }\n', '    \n', '    function _discountFirst() public view returns (bool) {\n', '        return discountFirst;\n', '    }\n', '\t\n', '\tfunction _userSponsor(address _user) public view returns (address) {\n', '        return users[_user].sponsor;\n', '    }\n', '\n', '    function transfer(address _recipient, uint256 _tokenAmount) public virtual returns (bool) {\n', '\n', '        if (_recipient == address(this)) {\n', '\n', '            uint date = block.timestamp;\n', '            uint rate = _tokenRate(0);\n', '            uint etherAmount = _tokenAmount.mul(rate).div(10**18);\n', '            \n', '            _burn(_msgSender(), _tokenAmount);\n', '\n', '            sendValue(_msgSender(), etherAmount);\n', '            \n', '            emit Sell(_msgSender(), _tokenAmount, rate, etherAmount, date);\n', '\n', '        } else {\n', '            _transfer(_msgSender(), _recipient, _tokenAmount);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function _transfer(address _sender, address _recipient, uint256 _amount) internal virtual {\n', '        require(_sender != address(0), "ERC20: transfer from the zero address");\n', '        require(_recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[_sender] = _balances[_sender].sub(_amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[_recipient] = _balances[_recipient].add(_amount);\n', '        emit Transfer(_sender, _recipient, _amount);\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _amount) public returns (bool) {\n', '        _approve(_msgSender(), _spender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _sender, address _recipient, uint256 _amount) public virtual returns (bool) {\n', '        _transfer(_sender, _recipient, _amount);\n', '        _approve(_sender, _msgSender(), _allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    \n', '    function _mint(address _account, uint256 _amount) internal virtual {\n', '        require(_account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(_amount);\n', '        _balances[_account] = _balances[_account].add(_amount);\n', '        emit Transfer(address(0), _account, _amount);\n', '    }\n', '    \n', '    function _burn(address _account, uint256 _amount) internal virtual {\n', '        require(_account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[_account] = _balances[_account].sub(_amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(_amount);\n', '        emit Transfer(_account, address(0), _amount);\n', '    }\n', '    \n', '    function _approve(address _owner, address _spender, uint256 _amount) internal virtual {\n', '        require(_owner != address(0), "ERC20: approve from the zero address");\n', '        require(_spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[_owner][_spender] = _amount;\n', '        emit Approval(_owner, _spender, _amount);\n', '    }\n', '    \n', '    function sendValue(address payable _recipient, uint256 _amount) internal {\n', '        require(address(this).balance >= _amount, "Address: insufficient balance");\n', '        (bool success, ) = _recipient.call{ value: _amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '    \n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '    \n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _account) public view returns (uint256) {\n', '        return _balances[_account];\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return _allowances[_owner][_spender];\n', '    }\n', '    \n', '    function _tokenRate(uint _sum) private view returns (uint) {\n', '        \n', '        uint ttlspl = _totalSupply;\n', '        uint oldContractBalance = address(this).balance.sub(_sum);\n', '        \n', '        if (oldContractBalance == 0 || ttlspl == 0) {\n', '            return 10**16;\n', '        }\n', '        \n', '        return oldContractBalance.mul(10**18).div(ttlspl);\n', '    }\n', '    \n', '    function tokenAmountForEther(uint _sum) private view returns (uint, uint) {\n', '        uint rate = _tokenRate(_sum);\n', '        uint result = _sum.mul(10**18).div(rate);\n', '        return (result, rate);\n', '    }\n', '    \n', '    function calcTokenRate() public view returns (uint) {\n', '        uint ttlspl = _totalSupply;\n', '        uint actualContractBalance = address(this).balance;\n', '        if (actualContractBalance == 0 || ttlspl == 0) {\n', '            return 10**16;\n', '        }\n', '        return actualContractBalance.mul(10**18).div(ttlspl);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT']