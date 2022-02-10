['pragma solidity ^0.4.10;\n', '\n', 'contract AbstractSweeper {\n', '    function sweep(address token, uint amount) returns (bool);\n', '\n', '    function () { throw; }\n', '\n', '    Controller controller;\n', '\n', '    function AbstractSweeper(address _controller) {\n', '        controller = Controller(_controller);\n', '    }\n', '\n', '    modifier canSweep() {\n', '        if (msg.sender != controller.authorizedCaller() && msg.sender != controller.owner()) throw;\n', '        if (controller.halted()) throw;\n', '        _;\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    function balanceOf(address a) returns (uint) {\n', '        (a);\n', '        return 0;\n', '    }\n', '\n', '    function transfer(address a, uint val) returns (bool) {\n', '        (a);\n', '        (val);\n', '        return false;\n', '    }\n', '}\n', '\n', 'contract DefaultSweeper is AbstractSweeper {\n', '    function DefaultSweeper(address controller)\n', '             AbstractSweeper(controller) {}\n', '\n', '    function sweep(address _token, uint _amount)\n', '    canSweep\n', '    returns (bool) {\n', '        bool success = false;\n', '        address destination = controller.destination();\n', '\n', '        if (_token != address(0)) {\n', '            Token token = Token(_token);\n', '            uint amount = _amount;\n', '            if (amount > token.balanceOf(this)) {\n', '                return false;\n', '            }\n', '\n', '            success = token.transfer(destination, amount);\n', '        }\n', '        else {\n', '            uint amountInWei = _amount;\n', '            if (amountInWei > this.balance) {\n', '                return false;\n', '            }\n', '\n', '            success = destination.send(amountInWei);\n', '        }\n', '\n', '        if (success) {\n', '            controller.logSweep(this, destination, _token, _amount);\n', '        }\n', '        return success;\n', '    }\n', '}\n', '\n', 'contract UserWallet {\n', '    AbstractSweeperList sweeperList;\n', '    function UserWallet(address _sweeperlist) {\n', '        sweeperList = AbstractSweeperList(_sweeperlist);\n', '    }\n', '\n', '    function () public payable { }\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) {\n', '        (_from);\n', '        (_value);\n', '        (_data);\n', '     }\n', '\n', '    function sweep(address _token, uint _amount)\n', '    returns (bool) {\n', '        (_amount);\n', '        return sweeperList.sweeperOf(_token).delegatecall(msg.data);\n', '    }\n', '}\n', '\n', 'contract AbstractSweeperList {\n', '    function sweeperOf(address _token) returns (address);\n', '}\n', '\n', 'contract Controller is AbstractSweeperList {\n', '    address public owner;\n', '    address public authorizedCaller;\n', '\n', '    address public destination;\n', '\n', '    bool public halted;\n', '\n', '    event LogNewWallet(address receiver);\n', '    event LogSweep(address indexed from, address indexed to, address indexed token, uint amount);\n', '    \n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw; \n', '        _;\n', '    }\n', '\n', '    modifier onlyAuthorizedCaller() {\n', '        if (msg.sender != authorizedCaller) throw; \n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmins() {\n', '        if (msg.sender != authorizedCaller && msg.sender != owner) throw; \n', '        _;\n', '    }\n', '\n', '    function Controller() \n', '    {\n', '        owner = msg.sender;\n', '        destination = msg.sender;\n', '        authorizedCaller = msg.sender;\n', '    }\n', '\n', '    function changeAuthorizedCaller(address _newCaller) onlyOwner {\n', '        authorizedCaller = _newCaller;\n', '    }\n', '\n', '    function changeDestination(address _dest) onlyOwner {\n', '        destination = _dest;\n', '    }\n', '\n', '    function changeOwner(address _owner) onlyOwner {\n', '        owner = _owner;\n', '    }\n', '\n', '    function makeWallet() onlyAdmins returns (address wallet)  {\n', '        wallet = address(new UserWallet(this));\n', '        LogNewWallet(wallet);\n', '    }\n', '\n', '    function halt() onlyAdmins {\n', '        halted = true;\n', '    }\n', '\n', '    function start() onlyOwner {\n', '        halted = false;\n', '    }\n', '\n', '    address public defaultSweeper = address(new DefaultSweeper(this));\n', '    mapping (address => address) sweepers;\n', '\n', '    function addSweeper(address _token, address _sweeper) onlyOwner {\n', '        sweepers[_token] = _sweeper;\n', '    }\n', '\n', '    function sweeperOf(address _token) returns (address) {\n', '        address sweeper = sweepers[_token];\n', '        if (sweeper == 0) sweeper = defaultSweeper;\n', '        return sweeper;\n', '    }\n', '\n', '    function logSweep(address from, address to, address token, uint amount) {\n', '        LogSweep(from, to, token, amount);\n', '    }\n', '}']
['pragma solidity ^0.4.10;\n', '\n', 'contract AbstractSweeper {\n', '    function sweep(address token, uint amount) returns (bool);\n', '\n', '    function () { throw; }\n', '\n', '    Controller controller;\n', '\n', '    function AbstractSweeper(address _controller) {\n', '        controller = Controller(_controller);\n', '    }\n', '\n', '    modifier canSweep() {\n', '        if (msg.sender != controller.authorizedCaller() && msg.sender != controller.owner()) throw;\n', '        if (controller.halted()) throw;\n', '        _;\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    function balanceOf(address a) returns (uint) {\n', '        (a);\n', '        return 0;\n', '    }\n', '\n', '    function transfer(address a, uint val) returns (bool) {\n', '        (a);\n', '        (val);\n', '        return false;\n', '    }\n', '}\n', '\n', 'contract DefaultSweeper is AbstractSweeper {\n', '    function DefaultSweeper(address controller)\n', '             AbstractSweeper(controller) {}\n', '\n', '    function sweep(address _token, uint _amount)\n', '    canSweep\n', '    returns (bool) {\n', '        bool success = false;\n', '        address destination = controller.destination();\n', '\n', '        if (_token != address(0)) {\n', '            Token token = Token(_token);\n', '            uint amount = _amount;\n', '            if (amount > token.balanceOf(this)) {\n', '                return false;\n', '            }\n', '\n', '            success = token.transfer(destination, amount);\n', '        }\n', '        else {\n', '            uint amountInWei = _amount;\n', '            if (amountInWei > this.balance) {\n', '                return false;\n', '            }\n', '\n', '            success = destination.send(amountInWei);\n', '        }\n', '\n', '        if (success) {\n', '            controller.logSweep(this, destination, _token, _amount);\n', '        }\n', '        return success;\n', '    }\n', '}\n', '\n', 'contract UserWallet {\n', '    AbstractSweeperList sweeperList;\n', '    function UserWallet(address _sweeperlist) {\n', '        sweeperList = AbstractSweeperList(_sweeperlist);\n', '    }\n', '\n', '    function () public payable { }\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) {\n', '        (_from);\n', '        (_value);\n', '        (_data);\n', '     }\n', '\n', '    function sweep(address _token, uint _amount)\n', '    returns (bool) {\n', '        (_amount);\n', '        return sweeperList.sweeperOf(_token).delegatecall(msg.data);\n', '    }\n', '}\n', '\n', 'contract AbstractSweeperList {\n', '    function sweeperOf(address _token) returns (address);\n', '}\n', '\n', 'contract Controller is AbstractSweeperList {\n', '    address public owner;\n', '    address public authorizedCaller;\n', '\n', '    address public destination;\n', '\n', '    bool public halted;\n', '\n', '    event LogNewWallet(address receiver);\n', '    event LogSweep(address indexed from, address indexed to, address indexed token, uint amount);\n', '    \n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw; \n', '        _;\n', '    }\n', '\n', '    modifier onlyAuthorizedCaller() {\n', '        if (msg.sender != authorizedCaller) throw; \n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmins() {\n', '        if (msg.sender != authorizedCaller && msg.sender != owner) throw; \n', '        _;\n', '    }\n', '\n', '    function Controller() \n', '    {\n', '        owner = msg.sender;\n', '        destination = msg.sender;\n', '        authorizedCaller = msg.sender;\n', '    }\n', '\n', '    function changeAuthorizedCaller(address _newCaller) onlyOwner {\n', '        authorizedCaller = _newCaller;\n', '    }\n', '\n', '    function changeDestination(address _dest) onlyOwner {\n', '        destination = _dest;\n', '    }\n', '\n', '    function changeOwner(address _owner) onlyOwner {\n', '        owner = _owner;\n', '    }\n', '\n', '    function makeWallet() onlyAdmins returns (address wallet)  {\n', '        wallet = address(new UserWallet(this));\n', '        LogNewWallet(wallet);\n', '    }\n', '\n', '    function halt() onlyAdmins {\n', '        halted = true;\n', '    }\n', '\n', '    function start() onlyOwner {\n', '        halted = false;\n', '    }\n', '\n', '    address public defaultSweeper = address(new DefaultSweeper(this));\n', '    mapping (address => address) sweepers;\n', '\n', '    function addSweeper(address _token, address _sweeper) onlyOwner {\n', '        sweepers[_token] = _sweeper;\n', '    }\n', '\n', '    function sweeperOf(address _token) returns (address) {\n', '        address sweeper = sweepers[_token];\n', '        if (sweeper == 0) sweeper = defaultSweeper;\n', '        return sweeper;\n', '    }\n', '\n', '    function logSweep(address from, address to, address token, uint amount) {\n', '        LogSweep(from, to, token, amount);\n', '    }\n', '}']