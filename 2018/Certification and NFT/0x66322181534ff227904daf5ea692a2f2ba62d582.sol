['pragma solidity 0.4.23;\n', '\n', '// Random lottery\n', '// Smart contracts can&#39;t bet\n', '\n', '// Pay 0.001 to get a random number\n', '// If your random number is the highest so far you&#39;re in the lead\n', '// If no one beats you in 1 day you can claim your winnnings - the entire balance.\n', '\n', 'contract RandoLotto {\n', '    \n', '    uint256 public highScore;\n', '    address public currentWinner;\n', '    uint256 public lastTimestamp;\n', '    \n', '    constructor () public {\n', '        highScore = 0;\n', '        currentWinner = msg.sender;\n', '        lastTimestamp = now;\n', '    }\n', '    \n', '    function () public payable {\n', '        require(msg.sender == tx.origin);\n', '        require(msg.value >= 0.001 ether);\n', '    \n', '        uint256 randomNumber = uint256(keccak256(blockhash(block.number - 1)));\n', '        \n', '        if (randomNumber > highScore) {\n', '            currentWinner = msg.sender;\n', '            lastTimestamp = now;\n', '        }\n', '    }\n', '    \n', '    function claimWinnings() public {\n', '        require(now > lastTimestamp + 1 days);\n', '        require(msg.sender == currentWinner);\n', '        \n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '}']
['pragma solidity 0.4.23;\n', '\n', '// Random lottery\n', "// Smart contracts can't bet\n", '\n', '// Pay 0.001 to get a random number\n', "// If your random number is the highest so far you're in the lead\n", '// If no one beats you in 1 day you can claim your winnnings - the entire balance.\n', '\n', 'contract RandoLotto {\n', '    \n', '    uint256 public highScore;\n', '    address public currentWinner;\n', '    uint256 public lastTimestamp;\n', '    \n', '    constructor () public {\n', '        highScore = 0;\n', '        currentWinner = msg.sender;\n', '        lastTimestamp = now;\n', '    }\n', '    \n', '    function () public payable {\n', '        require(msg.sender == tx.origin);\n', '        require(msg.value >= 0.001 ether);\n', '    \n', '        uint256 randomNumber = uint256(keccak256(blockhash(block.number - 1)));\n', '        \n', '        if (randomNumber > highScore) {\n', '            currentWinner = msg.sender;\n', '            lastTimestamp = now;\n', '        }\n', '    }\n', '    \n', '    function claimWinnings() public {\n', '        require(now > lastTimestamp + 1 days);\n', '        require(msg.sender == currentWinner);\n', '        \n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '}']