['pragma solidity ^0.4.11;\n', '\n', 'contract ERC20 \n', '{\n', '    function totalSupply() constant returns (uint);\n', '    function balanceOf(address who) constant returns (uint);\n', '    function allowance(address owner, address spender) constant returns (uint);\n', '    function transfer(address to, uint value) returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) returns (bool ok);\n', '    function approve(address spender, uint value) returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract workForce\n', '{\n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyEmployee()\n', '    {\n', '        require(workcrew[ employeeAddressIndex[msg.sender] ].yearlySalaryUSD > 0);\n', '         _;\n', '    }\n', '\n', '    /* Oracle address and owner address are the same */\n', '    modifier onlyOracle()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    struct Employee\n', '    {\n', '        uint employeeId;\n', '        string employeeName;\n', '        address employeeAddress;\n', '        uint[3] usdEthAntTokenDistribution;\n', '        uint yearlySalaryUSD;\n', '        uint startDate;\n', '        uint lastPayday;\n', '        uint lastTokenConfigDay;\n', '    }\n', '\n', '    \n', '    /* Using a dynamic array because can&#39;t iterate mappings, or use push,length,delete cmds? */\n', '    Employee[] workcrew;\n', '    uint employeeIndex;\n', '    mapping( uint => uint ) employeeIdIndex;\n', '    mapping( string => uint ) employeeNameIndex;\n', '    mapping( address => uint ) employeeAddressIndex;\n', '    \n', '    mapping( address => uint ) public exchangeRates;\n', '    address owner;\n', '    uint creationDate;\n', '\n', '    /* ANT token is Catnip */\n', '    address antAddr = 0x529ae9b61c174a3e005eda67eb755342558a1c3f;\n', '    /* USD token is Space Dollars */\n', '    address usdAddr = 0x41f1dcb0d41bf1e143461faf42c577a9219da415;\n', '\n', '    ERC20 antToken = ERC20(antAddr);\n', '    ERC20 usdToken = ERC20(usdAddr);\n', '    /* set to 1 Ether equals 275.00 USD */\n', '    uint oneUsdToEtherRate;\n', '\n', '\n', '    /* Constructor sets 1USD to equal 3.2 Finney or 2 Catnip */\n', '    function workForce() public\n', '    {\n', '        owner = msg.sender;\n', '        creationDate = now;\n', '        employeeIndex = 1000;\n', '\n', '        exchangeRates[antAddr] = 2;\n', '        oneUsdToEtherRate = 3200000000000000;\n', '    }\n', '\n', '    function indexTheWorkcrew() private\n', '    {\n', '        for( uint x = 0; x < workcrew.length; x++ )\n', '        {\n', '            employeeIdIndex[ workcrew[x].employeeId ] = x;\n', '            employeeNameIndex[ workcrew[x].employeeName ] = x;\n', '            employeeAddressIndex[ workcrew[x].employeeAddress ] = x;\n', '        }\n', '    }\n', '\n', '    function incompletePercent(uint[3] _distribution) internal returns (bool)\n', '    {\n', '        uint sum;\n', '        for( uint x = 0; x < 3; x++ ){ sum += _distribution[x]; }\n', '        if( sum != 100 ){ return true; }\n', '        else{ return false; }\n', '    }\n', '\n', '    function addEmployee(address _employeeAddress, string _employeeName, uint[3] _tokenDistribution, uint _initialUSDYearlySalary) onlyOwner\n', '    {\n', '        if( incompletePercent( _tokenDistribution)){ revert; }\n', '        employeeIndex++;\n', '        Employee memory newEmployee;\n', '        newEmployee.employeeId = employeeIndex;\n', '        newEmployee.employeeName = _employeeName;\n', '        newEmployee.employeeAddress = _employeeAddress;\n', '        newEmployee.usdEthAntTokenDistribution = _tokenDistribution;\n', '        newEmployee.yearlySalaryUSD = _initialUSDYearlySalary;\n', '        newEmployee.startDate = now;\n', '        newEmployee.lastPayday = now;\n', '        newEmployee.lastTokenConfigDay = now;\n', '        workcrew.push(newEmployee);\n', '        indexTheWorkcrew();\n', '    }\n', '\n', '    function setEmployeeSalary(uint _employeeID, uint _yearlyUSDSalary) onlyOwner\n', '    {\n', '        workcrew[ employeeIdIndex[_employeeID] ].yearlySalaryUSD = _yearlyUSDSalary;\n', '    }\n', '\n', '    function removeEmployee(uint _employeeID) onlyOwner\n', '    {\n', '        delete workcrew[ employeeIdIndex[_employeeID] ];\n', '        indexTheWorkcrew();\n', '    }\n', '\n', '    function addFunds() payable onlyOwner returns (uint) \n', '    {\n', '        return this.balance;\n', '    }\n', '\n', '    function getTokenBalance() constant returns (uint, uint)\n', '    {\n', '        return ( usdToken.balanceOf(address(this)), antToken.balanceOf(address(this)) );\n', '    }\n', '\n', '    function scapeHatch() onlyOwner\n', '    {\n', '        selfdestructTokens();\n', '        delete workcrew;\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function selfdestructTokens() private\n', '    {\n', '        antToken.transfer( owner,(antToken.balanceOf(address(this))));\n', '        usdToken.transfer( owner, (usdToken.balanceOf(address(this))));\n', '    }\n', '\n', '    function getEmployeeCount() constant onlyOwner returns (uint)\n', '    {\n', '        return workcrew.length;\n', '    }\n', '\n', '    function getEmployeeInfoById(uint _employeeId) constant onlyOwner returns (uint, string, uint, address, uint)\n', '    {\n', '        uint x = employeeIdIndex[_employeeId];\n', '        return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,\n', '                workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );\n', '    }\n', '    \n', '    function getEmployeeInfoByName(string _employeeName) constant onlyOwner returns (uint, string, uint, address, uint)\n', '    {\n', '        uint x = employeeNameIndex[_employeeName];\n', '        return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,\n', '                workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );\n', '    }\n', '\n', '    function calculatePayrollBurnrate() constant onlyOwner returns (uint)\n', '    {\n', '        uint monthlyPayout;\n', '        for( uint x = 0; x < workcrew.length; x++ )\n', '        {\n', '            monthlyPayout += workcrew[x].yearlySalaryUSD / 12;\n', '        }\n', '        return monthlyPayout;\n', '    }\n', '\n', '    function calculatePayrollRunway() constant onlyOwner returns (uint)\n', '    {\n', '        uint dailyPayout = calculatePayrollBurnrate() / 30;\n', '        \n', '        uint UsdBalance = usdToken.balanceOf(address(this));\n', '        UsdBalance += this.balance / oneUsdToEtherRate;\n', '        UsdBalance += antToken.balanceOf(address(this)) / exchangeRates[antAddr];\n', '        \n', '        uint daysRemaining = UsdBalance / dailyPayout;\n', '        return daysRemaining;\n', '    }\n', '\n', '    function setPercentTokenAllocation(uint _usdTokens, uint _ethTokens, uint _antTokens) onlyEmployee\n', '    {\n', '        if( _usdTokens + _ethTokens + _antTokens != 100 ){revert;}\n', '        \n', '        uint x = employeeAddressIndex[msg.sender];\n', '\n', '        /* change from 1 hours to 24 weeks */\n', '        if( now < workcrew[x].lastTokenConfigDay + 1 hours ){revert;}\n', '        workcrew[x].lastTokenConfigDay = now;\n', '        workcrew[x].usdEthAntTokenDistribution[0] = _usdTokens;\n', '        workcrew[x].usdEthAntTokenDistribution[1] = _ethTokens;\n', '        workcrew[x].usdEthAntTokenDistribution[2] = _antTokens;\n', '    }\n', '\n', '    /* Eventually change this so that a missed payday will carry owed pay over to next payperiod */\n', '    function payday(uint _employeeId) public onlyEmployee\n', '    {\n', '        uint x = employeeIdIndex[_employeeId];\n', '\n', '        /* Change to 4 weeks for monthly pay period */\n', '        if( now < workcrew[x].lastPayday + 15 minutes ){ revert; }\n', '        if( msg.sender != workcrew[x].employeeAddress ){ revert; }\n', '        workcrew[x].lastPayday = now;\n', '\n', '        /* 7680 is for 15min pay periods. Change to 12 for monthly pay period */\n', '        uint paycheck = workcrew[x].yearlySalaryUSD / 7680;\n', '        uint usdTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[0] / 100;\n', '        uint ethTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[1] / 100;\n', '        uint antTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[2] / 100;\n', '        \n', '        ethTransferAmount = ethTransferAmount * oneUsdToEtherRate;\n', '        msg.sender.transfer(ethTransferAmount);\n', '        antTransferAmount = antTransferAmount * exchangeRates[antAddr];\n', '        antToken.transfer( workcrew[x].employeeAddress, antTransferAmount );\n', '        usdToken.transfer( workcrew[x].employeeAddress, usdTransferAmount );\n', '    }\n', '    \n', '    /* setting 1 USD equals X amount of tokens */\n', '    function setTokenExchangeRate(address _token, uint _tokenValue) onlyOracle\n', '    {\n', '        exchangeRates[_token] = _tokenValue;\n', '    }\n', '\n', '    /* setting 1 USD equals X amount of wei */\n', '    function setUsdToEtherExchangeRate(uint _weiValue) onlyOracle\n', '    {\n', '        oneUsdToEtherRate = _weiValue;\n', '    }\n', '\n', '    function UsdToEtherConvert(uint _UsdAmount) constant returns (uint)\n', '    {\n', '        uint etherVal = _UsdAmount * oneUsdToEtherRate;\n', '        return etherVal;\n', '    }\n', '\n', '    function UsdToTokenConvert(address _token, uint _UsdAmount) constant returns (uint)\n', '    {\n', '        uint tokenAmount = _UsdAmount * exchangeRates[_token];\n', '        return tokenAmount;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract ERC20 \n', '{\n', '    function totalSupply() constant returns (uint);\n', '    function balanceOf(address who) constant returns (uint);\n', '    function allowance(address owner, address spender) constant returns (uint);\n', '    function transfer(address to, uint value) returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) returns (bool ok);\n', '    function approve(address spender, uint value) returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract workForce\n', '{\n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyEmployee()\n', '    {\n', '        require(workcrew[ employeeAddressIndex[msg.sender] ].yearlySalaryUSD > 0);\n', '         _;\n', '    }\n', '\n', '    /* Oracle address and owner address are the same */\n', '    modifier onlyOracle()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    struct Employee\n', '    {\n', '        uint employeeId;\n', '        string employeeName;\n', '        address employeeAddress;\n', '        uint[3] usdEthAntTokenDistribution;\n', '        uint yearlySalaryUSD;\n', '        uint startDate;\n', '        uint lastPayday;\n', '        uint lastTokenConfigDay;\n', '    }\n', '\n', '    \n', "    /* Using a dynamic array because can't iterate mappings, or use push,length,delete cmds? */\n", '    Employee[] workcrew;\n', '    uint employeeIndex;\n', '    mapping( uint => uint ) employeeIdIndex;\n', '    mapping( string => uint ) employeeNameIndex;\n', '    mapping( address => uint ) employeeAddressIndex;\n', '    \n', '    mapping( address => uint ) public exchangeRates;\n', '    address owner;\n', '    uint creationDate;\n', '\n', '    /* ANT token is Catnip */\n', '    address antAddr = 0x529ae9b61c174a3e005eda67eb755342558a1c3f;\n', '    /* USD token is Space Dollars */\n', '    address usdAddr = 0x41f1dcb0d41bf1e143461faf42c577a9219da415;\n', '\n', '    ERC20 antToken = ERC20(antAddr);\n', '    ERC20 usdToken = ERC20(usdAddr);\n', '    /* set to 1 Ether equals 275.00 USD */\n', '    uint oneUsdToEtherRate;\n', '\n', '\n', '    /* Constructor sets 1USD to equal 3.2 Finney or 2 Catnip */\n', '    function workForce() public\n', '    {\n', '        owner = msg.sender;\n', '        creationDate = now;\n', '        employeeIndex = 1000;\n', '\n', '        exchangeRates[antAddr] = 2;\n', '        oneUsdToEtherRate = 3200000000000000;\n', '    }\n', '\n', '    function indexTheWorkcrew() private\n', '    {\n', '        for( uint x = 0; x < workcrew.length; x++ )\n', '        {\n', '            employeeIdIndex[ workcrew[x].employeeId ] = x;\n', '            employeeNameIndex[ workcrew[x].employeeName ] = x;\n', '            employeeAddressIndex[ workcrew[x].employeeAddress ] = x;\n', '        }\n', '    }\n', '\n', '    function incompletePercent(uint[3] _distribution) internal returns (bool)\n', '    {\n', '        uint sum;\n', '        for( uint x = 0; x < 3; x++ ){ sum += _distribution[x]; }\n', '        if( sum != 100 ){ return true; }\n', '        else{ return false; }\n', '    }\n', '\n', '    function addEmployee(address _employeeAddress, string _employeeName, uint[3] _tokenDistribution, uint _initialUSDYearlySalary) onlyOwner\n', '    {\n', '        if( incompletePercent( _tokenDistribution)){ revert; }\n', '        employeeIndex++;\n', '        Employee memory newEmployee;\n', '        newEmployee.employeeId = employeeIndex;\n', '        newEmployee.employeeName = _employeeName;\n', '        newEmployee.employeeAddress = _employeeAddress;\n', '        newEmployee.usdEthAntTokenDistribution = _tokenDistribution;\n', '        newEmployee.yearlySalaryUSD = _initialUSDYearlySalary;\n', '        newEmployee.startDate = now;\n', '        newEmployee.lastPayday = now;\n', '        newEmployee.lastTokenConfigDay = now;\n', '        workcrew.push(newEmployee);\n', '        indexTheWorkcrew();\n', '    }\n', '\n', '    function setEmployeeSalary(uint _employeeID, uint _yearlyUSDSalary) onlyOwner\n', '    {\n', '        workcrew[ employeeIdIndex[_employeeID] ].yearlySalaryUSD = _yearlyUSDSalary;\n', '    }\n', '\n', '    function removeEmployee(uint _employeeID) onlyOwner\n', '    {\n', '        delete workcrew[ employeeIdIndex[_employeeID] ];\n', '        indexTheWorkcrew();\n', '    }\n', '\n', '    function addFunds() payable onlyOwner returns (uint) \n', '    {\n', '        return this.balance;\n', '    }\n', '\n', '    function getTokenBalance() constant returns (uint, uint)\n', '    {\n', '        return ( usdToken.balanceOf(address(this)), antToken.balanceOf(address(this)) );\n', '    }\n', '\n', '    function scapeHatch() onlyOwner\n', '    {\n', '        selfdestructTokens();\n', '        delete workcrew;\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function selfdestructTokens() private\n', '    {\n', '        antToken.transfer( owner,(antToken.balanceOf(address(this))));\n', '        usdToken.transfer( owner, (usdToken.balanceOf(address(this))));\n', '    }\n', '\n', '    function getEmployeeCount() constant onlyOwner returns (uint)\n', '    {\n', '        return workcrew.length;\n', '    }\n', '\n', '    function getEmployeeInfoById(uint _employeeId) constant onlyOwner returns (uint, string, uint, address, uint)\n', '    {\n', '        uint x = employeeIdIndex[_employeeId];\n', '        return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,\n', '                workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );\n', '    }\n', '    \n', '    function getEmployeeInfoByName(string _employeeName) constant onlyOwner returns (uint, string, uint, address, uint)\n', '    {\n', '        uint x = employeeNameIndex[_employeeName];\n', '        return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,\n', '                workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );\n', '    }\n', '\n', '    function calculatePayrollBurnrate() constant onlyOwner returns (uint)\n', '    {\n', '        uint monthlyPayout;\n', '        for( uint x = 0; x < workcrew.length; x++ )\n', '        {\n', '            monthlyPayout += workcrew[x].yearlySalaryUSD / 12;\n', '        }\n', '        return monthlyPayout;\n', '    }\n', '\n', '    function calculatePayrollRunway() constant onlyOwner returns (uint)\n', '    {\n', '        uint dailyPayout = calculatePayrollBurnrate() / 30;\n', '        \n', '        uint UsdBalance = usdToken.balanceOf(address(this));\n', '        UsdBalance += this.balance / oneUsdToEtherRate;\n', '        UsdBalance += antToken.balanceOf(address(this)) / exchangeRates[antAddr];\n', '        \n', '        uint daysRemaining = UsdBalance / dailyPayout;\n', '        return daysRemaining;\n', '    }\n', '\n', '    function setPercentTokenAllocation(uint _usdTokens, uint _ethTokens, uint _antTokens) onlyEmployee\n', '    {\n', '        if( _usdTokens + _ethTokens + _antTokens != 100 ){revert;}\n', '        \n', '        uint x = employeeAddressIndex[msg.sender];\n', '\n', '        /* change from 1 hours to 24 weeks */\n', '        if( now < workcrew[x].lastTokenConfigDay + 1 hours ){revert;}\n', '        workcrew[x].lastTokenConfigDay = now;\n', '        workcrew[x].usdEthAntTokenDistribution[0] = _usdTokens;\n', '        workcrew[x].usdEthAntTokenDistribution[1] = _ethTokens;\n', '        workcrew[x].usdEthAntTokenDistribution[2] = _antTokens;\n', '    }\n', '\n', '    /* Eventually change this so that a missed payday will carry owed pay over to next payperiod */\n', '    function payday(uint _employeeId) public onlyEmployee\n', '    {\n', '        uint x = employeeIdIndex[_employeeId];\n', '\n', '        /* Change to 4 weeks for monthly pay period */\n', '        if( now < workcrew[x].lastPayday + 15 minutes ){ revert; }\n', '        if( msg.sender != workcrew[x].employeeAddress ){ revert; }\n', '        workcrew[x].lastPayday = now;\n', '\n', '        /* 7680 is for 15min pay periods. Change to 12 for monthly pay period */\n', '        uint paycheck = workcrew[x].yearlySalaryUSD / 7680;\n', '        uint usdTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[0] / 100;\n', '        uint ethTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[1] / 100;\n', '        uint antTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[2] / 100;\n', '        \n', '        ethTransferAmount = ethTransferAmount * oneUsdToEtherRate;\n', '        msg.sender.transfer(ethTransferAmount);\n', '        antTransferAmount = antTransferAmount * exchangeRates[antAddr];\n', '        antToken.transfer( workcrew[x].employeeAddress, antTransferAmount );\n', '        usdToken.transfer( workcrew[x].employeeAddress, usdTransferAmount );\n', '    }\n', '    \n', '    /* setting 1 USD equals X amount of tokens */\n', '    function setTokenExchangeRate(address _token, uint _tokenValue) onlyOracle\n', '    {\n', '        exchangeRates[_token] = _tokenValue;\n', '    }\n', '\n', '    /* setting 1 USD equals X amount of wei */\n', '    function setUsdToEtherExchangeRate(uint _weiValue) onlyOracle\n', '    {\n', '        oneUsdToEtherRate = _weiValue;\n', '    }\n', '\n', '    function UsdToEtherConvert(uint _UsdAmount) constant returns (uint)\n', '    {\n', '        uint etherVal = _UsdAmount * oneUsdToEtherRate;\n', '        return etherVal;\n', '    }\n', '\n', '    function UsdToTokenConvert(address _token, uint _UsdAmount) constant returns (uint)\n', '    {\n', '        uint tokenAmount = _UsdAmount * exchangeRates[_token];\n', '        return tokenAmount;\n', '    }\n', '}']
