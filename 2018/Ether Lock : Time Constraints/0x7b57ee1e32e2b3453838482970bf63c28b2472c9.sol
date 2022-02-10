['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// token contract interface\n', 'interface Token{\n', '    function balanceOf(address user) external returns(uint256);\n', '    function transfer(address to, uint256 amount) external returns(bool);\n', '}\n', '\n', 'contract Safe{\n', '    using SafeMath for uint256;\n', '    \n', '    // counter for signing transactions\n', '    uint8 public count;\n', '    \n', '    uint256 internal end;\n', '    uint256 internal timeOutAuthentication;\n', '    \n', '    // arrays of safe keys\n', '    mapping (address => bool) internal safeKeys;\n', '    address [] internal massSafeKeys = new address[](4);\n', '    \n', '    // array of keys that signed the transaction\n', '    mapping (address => bool) internal signKeys;\n', '    \n', '    // free amount in safe\n', '    uint256 internal freeAmount; \n', '    // event transferring money to safe\n', '    bool internal tranche;\n', '    \n', '    // fixing lockup in safe\n', '    bool internal lockupIsSet;\n', '    \n', '    // lockup of safe\n', '    uint256 internal mainLockup; \n', '    \n', '    address internal lastSafeKey;\n', '    \n', '    Token public token;\n', '    \n', '    // Amount of cells\n', '    uint256 public countOfCell;\n', '    \n', '    // cell structure\n', '    struct _Cell{\n', '        uint256 lockup;\n', '        uint256 balance;\n', '        bool exist;\n', '        uint256 timeOfDeposit;\n', '    }\n', '    \n', '    // cell addresses\n', '    mapping (address => _Cell) internal userCells;\n', '    \n', '    event CreateCell(address indexed key);\n', '    event Deposit(address indexed key, uint256 balance);\n', '    event Delete(address indexed key);\n', '    event Edit(address indexed key, uint256 lockup);\n', '    event Withdraw(address indexed who, uint256 balance);\n', '    event InternalTransfer(address indexed from, address indexed to, uint256 balance);\n', '\n', '    modifier firstLevel() {\n', '        require(msg.sender == lastSafeKey);\n', '        require(count>=1);\n', '        require(now < end);\n', '        _;\n', '    }\n', '    \n', '    modifier secondLevel() {\n', '        require(msg.sender == lastSafeKey);\n', '        require(count>=2);\n', '        require(now < end);\n', '        _;\n', '    }\n', '    \n', '    modifier thirdLevel() {\n', '        require(msg.sender == lastSafeKey);\n', '        require(count>=3);\n', '        require(now < end);\n', '        _;\n', '    }\n', '    \n', '    constructor (address _first, address _second, address _third, address _fourth) public {\n', '        require(\n', '            _first != _second && \n', '            _first != _third && \n', '            _first != _fourth && \n', '            _second != _third &&\n', '            _second != _fourth &&\n', '            _third != _fourth &&\n', '            _first != 0x0 &&\n', '            _second != 0x0 &&\n', '            _third != 0x0 &&\n', '            _fourth != 0x0\n', '        );\n', '        safeKeys[_first] = true;\n', '        safeKeys[_second] = true;\n', '        safeKeys[_third] = true;\n', '        safeKeys[_fourth] = true;\n', '        massSafeKeys[0] = _first;\n', '        massSafeKeys[1] = _second;\n', '        massSafeKeys[2] = _third;\n', '        massSafeKeys[3] = _fourth;\n', '        timeOutAuthentication = 1 hours;\n', '    }\n', '    \n', '    function AuthStart() public returns(bool){\n', '        require(safeKeys[msg.sender]);\n', '        require(timeOutAuthentication >=0);\n', '        require(!signKeys[msg.sender]);\n', '        signKeys[msg.sender] = true;\n', '        count++;\n', '        end = now.add(timeOutAuthentication);\n', '        lastSafeKey = msg.sender;\n', '        return true;\n', '    }\n', '    \n', '    // completion of operation with safe-keys\n', '    function AuthEnd() public returns(bool){\n', '        require (safeKeys[msg.sender]);\n', '        for(uint i=0; i<4; i++){\n', '          signKeys[massSafeKeys[i]] = false;\n', '        }\n', '        count = 0;\n', '        end = 0;\n', '        lastSafeKey = 0x0;\n', '        return true;\n', '    }\n', '    \n', '    function getTimeOutAuthentication() firstLevel public view returns(uint256){\n', '        return timeOutAuthentication;\n', '    }\n', '    \n', '    function getFreeAmount() firstLevel public view returns(uint256){\n', '        return freeAmount;\n', '    }\n', '    \n', '    function getLockupCell(address _user) firstLevel public view returns(uint256){\n', '        return userCells[_user].lockup;\n', '    }\n', '    \n', '    function getBalanceCell(address _user) firstLevel public view returns(uint256){\n', '        return userCells[_user].balance;\n', '    }\n', '    \n', '    function getExistCell(address _user) firstLevel public view returns(bool){\n', '        return userCells[_user].exist;\n', '    }\n', '    \n', '    function getSafeKey(uint i) firstLevel view public returns(address){\n', '        return massSafeKeys[i];\n', '    }\n', '    \n', '    // withdrawal tokens from safe for issuer\n', '    function AssetWithdraw(address _to, uint256 _balance) secondLevel public returns(bool){\n', '        require(_balance<=freeAmount);\n', '        require(now>=mainLockup);\n', '        freeAmount = freeAmount.sub(_balance);\n', '        token.transfer(_to, _balance);\n', '        emit Withdraw(this, _balance);\n', '        return true;\n', '    }\n', '    \n', '    function setCell(address _cell, uint256 _lockup) secondLevel public returns(bool){\n', '        require(userCells[_cell].lockup==0 && userCells[_cell].balance==0);\n', '        require(!userCells[_cell].exist);\n', '        require(_lockup >= mainLockup);\n', '        userCells[_cell].lockup = _lockup;\n', '        userCells[_cell].exist = true;\n', '        countOfCell = countOfCell.add(1);\n', '        emit CreateCell(_cell);\n', '        return true;\n', '    }\n', '\n', '    function deleteCell(address _key) secondLevel public returns(bool){\n', '        require(getBalanceCell(_key)==0);\n', '        require(userCells[_key].exist);\n', '        userCells[_key].lockup = 0;\n', '        userCells[_key].exist = false;\n', '        countOfCell = countOfCell.sub(1);\n', '        emit Delete(_key);\n', '        return true;\n', '    }\n', '    \n', '    // change parameters of the cell\n', '    function editCell(address _key, uint256 _lockup) secondLevel public returns(bool){\n', '        require(getBalanceCell(_key)==0);\n', '        require(_lockup>= mainLockup);\n', '        require(userCells[_key].exist);\n', '        userCells[_key].lockup = _lockup;\n', '        emit Edit(_key, _lockup);\n', '        return true;\n', '    }\n', '\n', '    function depositCell(address _key, uint256 _balance) secondLevel public returns(bool){\n', '        require(userCells[_key].exist);\n', '        require(_balance<=freeAmount);\n', '        freeAmount = freeAmount.sub(_balance);\n', '        userCells[_key].balance = userCells[_key].balance.add(_balance);\n', '        userCells[_key].timeOfDeposit = now;\n', '        emit Deposit(_key, _balance);\n', '        return true;\n', '    }\n', '    \n', '    function changeDepositCell(address _key, uint256 _balance) secondLevel public returns(bool){\n', '        require(userCells[_key].timeOfDeposit.add(1 hours)>now);\n', '        userCells[_key].balance = userCells[_key].balance.sub(_balance);\n', '        freeAmount = freeAmount.add(_balance);\n', '        return true;\n', '    }\n', '    \n', '    // installation of a lockup for safe, \n', '    // fixing free amount on balance, \n', '    // token installation\n', '    // (run once)\n', '    function setContract(Token _token, uint256 _lockup) thirdLevel public returns(bool){\n', '        require(_token != address(0x0));\n', '        require(!lockupIsSet);\n', '        require(!tranche);\n', '        token = _token;\n', '        freeAmount = getMainBalance();\n', '        mainLockup = _lockup;\n', '        tranche = true;\n', '        lockupIsSet = true;\n', '        return true;\n', '    }\n', '    \n', '    // change of safe-key\n', '    function changeKey(address _oldKey, address _newKey) thirdLevel public returns(bool){\n', '        require(safeKeys[_oldKey]);\n', '        require(_newKey != 0x0);\n', '        for(uint i=0; i<4; i++){\n', '          if(massSafeKeys[i]==_oldKey){\n', '            massSafeKeys[i] = _newKey;\n', '          }\n', '        }\n', '        safeKeys[_oldKey] = false;\n', '        safeKeys[_newKey] = true;\n', '        \n', '        if(_oldKey==lastSafeKey){\n', '            lastSafeKey = _newKey;\n', '        }\n', '        \n', '        return true;\n', '    }\n', '\n', '    function setTimeOutAuthentication(uint256 _time) thirdLevel public returns(bool){\n', '        require(\n', '            _time > 0 && \n', '            timeOutAuthentication != _time &&\n', '            _time <= (5000 * 1 minutes)\n', '        );\n', '        timeOutAuthentication = _time;\n', '        return true;\n', '    }\n', '\n', '    function withdrawCell(uint256 _balance) public returns(bool){\n', '        require(userCells[msg.sender].balance >= _balance);\n', '        require(now >= userCells[msg.sender].lockup);\n', '        userCells[msg.sender].balance = userCells[msg.sender].balance.sub(_balance);\n', '        token.transfer(msg.sender, _balance);\n', '        emit Withdraw(msg.sender, _balance);\n', '        return true;\n', '    }\n', '    \n', '    // transferring tokens from one cell to another\n', '    function transferCell(address _to, uint256 _balance) public returns(bool){\n', '        require(userCells[msg.sender].balance >= _balance);\n', '        require(userCells[_to].lockup>=userCells[msg.sender].lockup);\n', '        require(userCells[_to].exist);\n', '        userCells[msg.sender].balance = userCells[msg.sender].balance.sub(_balance);\n', '        userCells[_to].balance = userCells[_to].balance.add(_balance);\n', '        emit InternalTransfer(msg.sender, _to, _balance);\n', '        return true;\n', '    }\n', '    \n', '    // information on balance of cell for holder\n', '    \n', '    function getInfoCellBalance() view public returns(uint256){\n', '        return userCells[msg.sender].balance;\n', '    }\n', '    \n', '    // information on lockup of cell for holder\n', '    \n', '    function getInfoCellLockup() view public returns(uint256){\n', '        return userCells[msg.sender].lockup;\n', '    }\n', '    \n', '    function getMainBalance() public view returns(uint256){\n', '        return token.balanceOf(this);\n', '    }\n', '    \n', '    function getMainLockup() public view returns(uint256){\n', '        return mainLockup;\n', '    }\n', '    \n', '    function isTimeOver() view public returns(bool){\n', '        if(now > end){\n', '            return true;\n', '        } else{\n', '            return false;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// token contract interface\n', 'interface Token{\n', '    function balanceOf(address user) external returns(uint256);\n', '    function transfer(address to, uint256 amount) external returns(bool);\n', '}\n', '\n', 'contract Safe{\n', '    using SafeMath for uint256;\n', '    \n', '    // counter for signing transactions\n', '    uint8 public count;\n', '    \n', '    uint256 internal end;\n', '    uint256 internal timeOutAuthentication;\n', '    \n', '    // arrays of safe keys\n', '    mapping (address => bool) internal safeKeys;\n', '    address [] internal massSafeKeys = new address[](4);\n', '    \n', '    // array of keys that signed the transaction\n', '    mapping (address => bool) internal signKeys;\n', '    \n', '    // free amount in safe\n', '    uint256 internal freeAmount; \n', '    // event transferring money to safe\n', '    bool internal tranche;\n', '    \n', '    // fixing lockup in safe\n', '    bool internal lockupIsSet;\n', '    \n', '    // lockup of safe\n', '    uint256 internal mainLockup; \n', '    \n', '    address internal lastSafeKey;\n', '    \n', '    Token public token;\n', '    \n', '    // Amount of cells\n', '    uint256 public countOfCell;\n', '    \n', '    // cell structure\n', '    struct _Cell{\n', '        uint256 lockup;\n', '        uint256 balance;\n', '        bool exist;\n', '        uint256 timeOfDeposit;\n', '    }\n', '    \n', '    // cell addresses\n', '    mapping (address => _Cell) internal userCells;\n', '    \n', '    event CreateCell(address indexed key);\n', '    event Deposit(address indexed key, uint256 balance);\n', '    event Delete(address indexed key);\n', '    event Edit(address indexed key, uint256 lockup);\n', '    event Withdraw(address indexed who, uint256 balance);\n', '    event InternalTransfer(address indexed from, address indexed to, uint256 balance);\n', '\n', '    modifier firstLevel() {\n', '        require(msg.sender == lastSafeKey);\n', '        require(count>=1);\n', '        require(now < end);\n', '        _;\n', '    }\n', '    \n', '    modifier secondLevel() {\n', '        require(msg.sender == lastSafeKey);\n', '        require(count>=2);\n', '        require(now < end);\n', '        _;\n', '    }\n', '    \n', '    modifier thirdLevel() {\n', '        require(msg.sender == lastSafeKey);\n', '        require(count>=3);\n', '        require(now < end);\n', '        _;\n', '    }\n', '    \n', '    constructor (address _first, address _second, address _third, address _fourth) public {\n', '        require(\n', '            _first != _second && \n', '            _first != _third && \n', '            _first != _fourth && \n', '            _second != _third &&\n', '            _second != _fourth &&\n', '            _third != _fourth &&\n', '            _first != 0x0 &&\n', '            _second != 0x0 &&\n', '            _third != 0x0 &&\n', '            _fourth != 0x0\n', '        );\n', '        safeKeys[_first] = true;\n', '        safeKeys[_second] = true;\n', '        safeKeys[_third] = true;\n', '        safeKeys[_fourth] = true;\n', '        massSafeKeys[0] = _first;\n', '        massSafeKeys[1] = _second;\n', '        massSafeKeys[2] = _third;\n', '        massSafeKeys[3] = _fourth;\n', '        timeOutAuthentication = 1 hours;\n', '    }\n', '    \n', '    function AuthStart() public returns(bool){\n', '        require(safeKeys[msg.sender]);\n', '        require(timeOutAuthentication >=0);\n', '        require(!signKeys[msg.sender]);\n', '        signKeys[msg.sender] = true;\n', '        count++;\n', '        end = now.add(timeOutAuthentication);\n', '        lastSafeKey = msg.sender;\n', '        return true;\n', '    }\n', '    \n', '    // completion of operation with safe-keys\n', '    function AuthEnd() public returns(bool){\n', '        require (safeKeys[msg.sender]);\n', '        for(uint i=0; i<4; i++){\n', '          signKeys[massSafeKeys[i]] = false;\n', '        }\n', '        count = 0;\n', '        end = 0;\n', '        lastSafeKey = 0x0;\n', '        return true;\n', '    }\n', '    \n', '    function getTimeOutAuthentication() firstLevel public view returns(uint256){\n', '        return timeOutAuthentication;\n', '    }\n', '    \n', '    function getFreeAmount() firstLevel public view returns(uint256){\n', '        return freeAmount;\n', '    }\n', '    \n', '    function getLockupCell(address _user) firstLevel public view returns(uint256){\n', '        return userCells[_user].lockup;\n', '    }\n', '    \n', '    function getBalanceCell(address _user) firstLevel public view returns(uint256){\n', '        return userCells[_user].balance;\n', '    }\n', '    \n', '    function getExistCell(address _user) firstLevel public view returns(bool){\n', '        return userCells[_user].exist;\n', '    }\n', '    \n', '    function getSafeKey(uint i) firstLevel view public returns(address){\n', '        return massSafeKeys[i];\n', '    }\n', '    \n', '    // withdrawal tokens from safe for issuer\n', '    function AssetWithdraw(address _to, uint256 _balance) secondLevel public returns(bool){\n', '        require(_balance<=freeAmount);\n', '        require(now>=mainLockup);\n', '        freeAmount = freeAmount.sub(_balance);\n', '        token.transfer(_to, _balance);\n', '        emit Withdraw(this, _balance);\n', '        return true;\n', '    }\n', '    \n', '    function setCell(address _cell, uint256 _lockup) secondLevel public returns(bool){\n', '        require(userCells[_cell].lockup==0 && userCells[_cell].balance==0);\n', '        require(!userCells[_cell].exist);\n', '        require(_lockup >= mainLockup);\n', '        userCells[_cell].lockup = _lockup;\n', '        userCells[_cell].exist = true;\n', '        countOfCell = countOfCell.add(1);\n', '        emit CreateCell(_cell);\n', '        return true;\n', '    }\n', '\n', '    function deleteCell(address _key) secondLevel public returns(bool){\n', '        require(getBalanceCell(_key)==0);\n', '        require(userCells[_key].exist);\n', '        userCells[_key].lockup = 0;\n', '        userCells[_key].exist = false;\n', '        countOfCell = countOfCell.sub(1);\n', '        emit Delete(_key);\n', '        return true;\n', '    }\n', '    \n', '    // change parameters of the cell\n', '    function editCell(address _key, uint256 _lockup) secondLevel public returns(bool){\n', '        require(getBalanceCell(_key)==0);\n', '        require(_lockup>= mainLockup);\n', '        require(userCells[_key].exist);\n', '        userCells[_key].lockup = _lockup;\n', '        emit Edit(_key, _lockup);\n', '        return true;\n', '    }\n', '\n', '    function depositCell(address _key, uint256 _balance) secondLevel public returns(bool){\n', '        require(userCells[_key].exist);\n', '        require(_balance<=freeAmount);\n', '        freeAmount = freeAmount.sub(_balance);\n', '        userCells[_key].balance = userCells[_key].balance.add(_balance);\n', '        userCells[_key].timeOfDeposit = now;\n', '        emit Deposit(_key, _balance);\n', '        return true;\n', '    }\n', '    \n', '    function changeDepositCell(address _key, uint256 _balance) secondLevel public returns(bool){\n', '        require(userCells[_key].timeOfDeposit.add(1 hours)>now);\n', '        userCells[_key].balance = userCells[_key].balance.sub(_balance);\n', '        freeAmount = freeAmount.add(_balance);\n', '        return true;\n', '    }\n', '    \n', '    // installation of a lockup for safe, \n', '    // fixing free amount on balance, \n', '    // token installation\n', '    // (run once)\n', '    function setContract(Token _token, uint256 _lockup) thirdLevel public returns(bool){\n', '        require(_token != address(0x0));\n', '        require(!lockupIsSet);\n', '        require(!tranche);\n', '        token = _token;\n', '        freeAmount = getMainBalance();\n', '        mainLockup = _lockup;\n', '        tranche = true;\n', '        lockupIsSet = true;\n', '        return true;\n', '    }\n', '    \n', '    // change of safe-key\n', '    function changeKey(address _oldKey, address _newKey) thirdLevel public returns(bool){\n', '        require(safeKeys[_oldKey]);\n', '        require(_newKey != 0x0);\n', '        for(uint i=0; i<4; i++){\n', '          if(massSafeKeys[i]==_oldKey){\n', '            massSafeKeys[i] = _newKey;\n', '          }\n', '        }\n', '        safeKeys[_oldKey] = false;\n', '        safeKeys[_newKey] = true;\n', '        \n', '        if(_oldKey==lastSafeKey){\n', '            lastSafeKey = _newKey;\n', '        }\n', '        \n', '        return true;\n', '    }\n', '\n', '    function setTimeOutAuthentication(uint256 _time) thirdLevel public returns(bool){\n', '        require(\n', '            _time > 0 && \n', '            timeOutAuthentication != _time &&\n', '            _time <= (5000 * 1 minutes)\n', '        );\n', '        timeOutAuthentication = _time;\n', '        return true;\n', '    }\n', '\n', '    function withdrawCell(uint256 _balance) public returns(bool){\n', '        require(userCells[msg.sender].balance >= _balance);\n', '        require(now >= userCells[msg.sender].lockup);\n', '        userCells[msg.sender].balance = userCells[msg.sender].balance.sub(_balance);\n', '        token.transfer(msg.sender, _balance);\n', '        emit Withdraw(msg.sender, _balance);\n', '        return true;\n', '    }\n', '    \n', '    // transferring tokens from one cell to another\n', '    function transferCell(address _to, uint256 _balance) public returns(bool){\n', '        require(userCells[msg.sender].balance >= _balance);\n', '        require(userCells[_to].lockup>=userCells[msg.sender].lockup);\n', '        require(userCells[_to].exist);\n', '        userCells[msg.sender].balance = userCells[msg.sender].balance.sub(_balance);\n', '        userCells[_to].balance = userCells[_to].balance.add(_balance);\n', '        emit InternalTransfer(msg.sender, _to, _balance);\n', '        return true;\n', '    }\n', '    \n', '    // information on balance of cell for holder\n', '    \n', '    function getInfoCellBalance() view public returns(uint256){\n', '        return userCells[msg.sender].balance;\n', '    }\n', '    \n', '    // information on lockup of cell for holder\n', '    \n', '    function getInfoCellLockup() view public returns(uint256){\n', '        return userCells[msg.sender].lockup;\n', '    }\n', '    \n', '    function getMainBalance() public view returns(uint256){\n', '        return token.balanceOf(this);\n', '    }\n', '    \n', '    function getMainLockup() public view returns(uint256){\n', '        return mainLockup;\n', '    }\n', '    \n', '    function isTimeOver() view public returns(bool){\n', '        if(now > end){\n', '            return true;\n', '        } else{\n', '            return false;\n', '        }\n', '    }\n', '}']