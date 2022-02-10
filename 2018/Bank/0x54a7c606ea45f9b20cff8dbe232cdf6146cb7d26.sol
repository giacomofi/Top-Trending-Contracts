['pragma solidity ^0.4.25;\n', '\n', 'contract ERC20 {\n', '    bytes32 public standard;\n', '    bytes32 public name;\n', '    bytes32 public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals;\n', '    bool public allowTransactions;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '}\n', '\n', '\n', 'contract ExToke {\n', '\n', '    string public name = "ExToke Token";\n', '    string public symbol = "XTE";\n', '    uint8 public decimals = 18;\n', '    \n', '    uint256 public crowdSaleSupply = 500000000  * (uint256(10) ** decimals);\n', '    uint256 public tokenSwapSupply = 3000000000 * (uint256(10) ** decimals);\n', '    uint256 public dividendSupply = 2400000000 * (uint256(10) ** decimals);\n', '    uint256 public totalSupply = 7000000000 * (uint256(10) ** decimals);\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    \n', '    \n', '    address public oldAddress = 0x28925299Ee1EDd8Fd68316eAA64b651456694f0f;\n', '    address tokenAdmin = 0xEd86f5216BCAFDd85E5875d35463Aca60925bF16;\n', '    \n', '    uint256 public finishTime = 1548057600;\n', '    \n', '    uint256[] public releaseDates = \n', '    [1543665600, 1546344000, 1549022400, 1551441600, 1554120000, 1556712000,\n', '    1559390400, 1561982400, 1564660800, 1567339200, 1569931200, 1572609600,\n', '    1575201600, 1577880000, 1580558400, 1583064000, 1585742400, 1588334400,\n', '    1591012800, 1593604800, 1596283200, 1598961600, 1601553600, 1604232000];\n', '    \n', '    uint256 public nextRelease = 0;\n', '\n', '    function ExToke() public {\n', '        balanceOf[tokenAdmin] = 1100000000 * (uint256(10) ** decimals);\n', '    }\n', '\n', '    uint256 public scaling = uint256(10) ** 8;\n', '\n', '    mapping(address => uint256) public scaledDividendBalanceOf;\n', '\n', '    uint256 public scaledDividendPerToken;\n', '\n', '    mapping(address => uint256) public scaledDividendCreditedTo;\n', '\n', '    function update(address account) internal {\n', '        if(nextRelease < 24 && block.timestamp > releaseDates[nextRelease]){\n', '            releaseDivTokens();\n', '        }\n', '        uint256 owed =\n', '            scaledDividendPerToken - scaledDividendCreditedTo[account];\n', '        scaledDividendBalanceOf[account] += balanceOf[account] * owed;\n', '        scaledDividendCreditedTo[account] = scaledDividendPerToken;\n', '        \n', '        \n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= value);\n', '\n', '        update(msg.sender);\n', '        update(to);\n', '\n', '        balanceOf[msg.sender] -= value;\n', '        balanceOf[to] += value;\n', '\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        require(value <= balanceOf[from]);\n', '        require(value <= allowance[from][msg.sender]);\n', '\n', '        update(from);\n', '        update(to);\n', '\n', '        balanceOf[from] -= value;\n', '        balanceOf[to] += value;\n', '        allowance[from][msg.sender] -= value;\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    uint256 public scaledRemainder = 0;\n', '    \n', '    function() public payable{\n', '        tokenAdmin.transfer(msg.value);\n', '        if(finishTime >= block.timestamp && crowdSaleSupply >= msg.value * 100000){\n', '            balanceOf[msg.sender] += msg.value * 100000;\n', '            crowdSaleSupply -= msg.value * 100000;\n', '            \n', '        }\n', '        else if(finishTime < block.timestamp){\n', '            balanceOf[tokenAdmin] += crowdSaleSupply;\n', '            crowdSaleSupply = 0;\n', '        }\n', '    }\n', '\n', '    function releaseDivTokens() public returns (bool success){\n', '        require(block.timestamp > releaseDates[nextRelease]);\n', '        uint256 releaseAmount = 100000000 * (uint256(10) ** decimals);\n', '        dividendSupply -= releaseAmount;\n', '        uint256 available = (releaseAmount * scaling) + scaledRemainder;\n', '        scaledDividendPerToken += available / totalSupply;\n', '        scaledRemainder = available % totalSupply;\n', '        nextRelease += 1;\n', '        return true;\n', '    }\n', '\n', '    function withdraw() public returns (bool success){\n', '        update(msg.sender);\n', '        uint256 amount = scaledDividendBalanceOf[msg.sender] / scaling;\n', '        scaledDividendBalanceOf[msg.sender] %= scaling;  // retain the remainder\n', '        balanceOf[msg.sender] += amount;\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    \n', '\n', '    function swap(uint256 sendAmount) returns (bool success){\n', '        require(tokenSwapSupply >= sendAmount * 3);\n', '        if(ERC20(oldAddress).transferFrom(msg.sender, tokenAdmin, sendAmount)){\n', '            balanceOf[msg.sender] += sendAmount * 3;\n', '            tokenSwapSupply -= sendAmount * 3;\n', '        }\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.25;\n', '\n', 'contract ERC20 {\n', '    bytes32 public standard;\n', '    bytes32 public name;\n', '    bytes32 public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals;\n', '    bool public allowTransactions;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '}\n', '\n', '\n', 'contract ExToke {\n', '\n', '    string public name = "ExToke Token";\n', '    string public symbol = "XTE";\n', '    uint8 public decimals = 18;\n', '    \n', '    uint256 public crowdSaleSupply = 500000000  * (uint256(10) ** decimals);\n', '    uint256 public tokenSwapSupply = 3000000000 * (uint256(10) ** decimals);\n', '    uint256 public dividendSupply = 2400000000 * (uint256(10) ** decimals);\n', '    uint256 public totalSupply = 7000000000 * (uint256(10) ** decimals);\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    \n', '    \n', '    address public oldAddress = 0x28925299Ee1EDd8Fd68316eAA64b651456694f0f;\n', '    address tokenAdmin = 0xEd86f5216BCAFDd85E5875d35463Aca60925bF16;\n', '    \n', '    uint256 public finishTime = 1548057600;\n', '    \n', '    uint256[] public releaseDates = \n', '    [1543665600, 1546344000, 1549022400, 1551441600, 1554120000, 1556712000,\n', '    1559390400, 1561982400, 1564660800, 1567339200, 1569931200, 1572609600,\n', '    1575201600, 1577880000, 1580558400, 1583064000, 1585742400, 1588334400,\n', '    1591012800, 1593604800, 1596283200, 1598961600, 1601553600, 1604232000];\n', '    \n', '    uint256 public nextRelease = 0;\n', '\n', '    function ExToke() public {\n', '        balanceOf[tokenAdmin] = 1100000000 * (uint256(10) ** decimals);\n', '    }\n', '\n', '    uint256 public scaling = uint256(10) ** 8;\n', '\n', '    mapping(address => uint256) public scaledDividendBalanceOf;\n', '\n', '    uint256 public scaledDividendPerToken;\n', '\n', '    mapping(address => uint256) public scaledDividendCreditedTo;\n', '\n', '    function update(address account) internal {\n', '        if(nextRelease < 24 && block.timestamp > releaseDates[nextRelease]){\n', '            releaseDivTokens();\n', '        }\n', '        uint256 owed =\n', '            scaledDividendPerToken - scaledDividendCreditedTo[account];\n', '        scaledDividendBalanceOf[account] += balanceOf[account] * owed;\n', '        scaledDividendCreditedTo[account] = scaledDividendPerToken;\n', '        \n', '        \n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= value);\n', '\n', '        update(msg.sender);\n', '        update(to);\n', '\n', '        balanceOf[msg.sender] -= value;\n', '        balanceOf[to] += value;\n', '\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        require(value <= balanceOf[from]);\n', '        require(value <= allowance[from][msg.sender]);\n', '\n', '        update(from);\n', '        update(to);\n', '\n', '        balanceOf[from] -= value;\n', '        balanceOf[to] += value;\n', '        allowance[from][msg.sender] -= value;\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    uint256 public scaledRemainder = 0;\n', '    \n', '    function() public payable{\n', '        tokenAdmin.transfer(msg.value);\n', '        if(finishTime >= block.timestamp && crowdSaleSupply >= msg.value * 100000){\n', '            balanceOf[msg.sender] += msg.value * 100000;\n', '            crowdSaleSupply -= msg.value * 100000;\n', '            \n', '        }\n', '        else if(finishTime < block.timestamp){\n', '            balanceOf[tokenAdmin] += crowdSaleSupply;\n', '            crowdSaleSupply = 0;\n', '        }\n', '    }\n', '\n', '    function releaseDivTokens() public returns (bool success){\n', '        require(block.timestamp > releaseDates[nextRelease]);\n', '        uint256 releaseAmount = 100000000 * (uint256(10) ** decimals);\n', '        dividendSupply -= releaseAmount;\n', '        uint256 available = (releaseAmount * scaling) + scaledRemainder;\n', '        scaledDividendPerToken += available / totalSupply;\n', '        scaledRemainder = available % totalSupply;\n', '        nextRelease += 1;\n', '        return true;\n', '    }\n', '\n', '    function withdraw() public returns (bool success){\n', '        update(msg.sender);\n', '        uint256 amount = scaledDividendBalanceOf[msg.sender] / scaling;\n', '        scaledDividendBalanceOf[msg.sender] %= scaling;  // retain the remainder\n', '        balanceOf[msg.sender] += amount;\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    \n', '\n', '    function swap(uint256 sendAmount) returns (bool success){\n', '        require(tokenSwapSupply >= sendAmount * 3);\n', '        if(ERC20(oldAddress).transferFrom(msg.sender, tokenAdmin, sendAmount)){\n', '            balanceOf[msg.sender] += sendAmount * 3;\n', '            tokenSwapSupply -= sendAmount * 3;\n', '        }\n', '        return true;\n', '    }\n', '\n', '}']
