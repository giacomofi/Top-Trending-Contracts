['pragma solidity ^0.4.19;\n', '\n', 'contract owned {\n', "    // Owner's address\n", '    address public owner;\n', '\n', '    // Hardcoded address of super owner (for security reasons)\n', '    address internal super_owner = 0x630CC4c83fCc1121feD041126227d25Bbeb51959;\n', '    \n', '    // Hardcoded addresses of founders for withdraw after gracePeriod is succeed (for security reasons)\n', '    address[2] internal foundersAddresses = [\n', '        0x2f072F00328B6176257C21E64925760990561001,\n', '        0x2640d4b3baF3F6CF9bB5732Fe37fE1a9735a32CE\n', '    ];\n', '\n', '    // Constructor of parent the contract\n', '    function owned() public {\n', '        owner = msg.sender;\n', '        super_owner = msg.sender; // DEBUG !!! \n', '    }\n', '\n', "    // Modifier for owner's functions of the contract\n", '    modifier onlyOwner {\n', '        if ((msg.sender != owner) && (msg.sender != super_owner)) revert();\n', '        _;\n', '    }\n', '\n', "    // Modifier for super-owner's functions of the contract\n", '    modifier onlySuperOwner {\n', '        if (msg.sender != super_owner) revert();\n', '        _;\n', '    }\n', '\n', '    // Return true if sender is owner or super-owner of the contract\n', '    function isOwner() internal returns(bool success) {\n', '        if ((msg.sender == owner) || (msg.sender == super_owner)) return true;\n', '        return false;\n', '    }\n', '\n', '    // Change the owner of the contract\n', '    function transferOwnership(address newOwner)  public onlySuperOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract STE {\n', '    function totalSupply() public returns(uint256);\n', '    function balanceOf(address _addr) public returns(uint256);\n', '}\n', '\n', '\n', 'contract STE_Poll is owned {\n', '\t// ERC20 \n', "\tstring public standard = 'Token 0.1';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    // ---\n', '    \n', '    uint256 public ethRaised;\n', '    uint256 public soldSupply;\n', '    uint256 public curPrice;\n', '    uint256 public minBuyPrice;\n', '    uint256 public maxBuyPrice;\n', '    \n', '    // Poll start and stop blocks\n', '    uint256 public pStartBlock;\n', '    uint256 public pStopBlock;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    // Constructor\n', '    function STE_Poll() public {        \n', '    \ttotalSupply = 0;\n', '    \tbalanceOf[this] = totalSupply;\n', '    \tdecimals = 8;\n', '        \n', '        name = "STE Poll";\n', '        symbol = "STE(poll)";\n', '        \n', '        pStartBlock = block.number;\n', '        pStopBlock = block.number + 20;\n', '    }\n', '    \n', '    // Calls when send Ethereum to the contract\n', '    function() internal payable {\n', '        if ( balanceOf[msg.sender] > 0 ) revert();\n', '        if ( ( block.number >= pStopBlock ) || ( block.number < pStartBlock ) ) revert();\n', '        \n', '        STE ste_contract = STE(0xeBa49DDea9F59F0a80EcbB1fb7A585ce0bFe5a5e);\n', '    \tuint256 amount = ste_contract.balanceOf(msg.sender);\n', '    \t\n', '    \tbalanceOf[msg.sender] += amount;\n', '        totalSupply += amount;\n', '    }\n', '    \n', '\t// ERC20 transfer\n', '    function transfer(address _to, uint256 _value) public {\n', '    \trevert();\n', '    }\n', '\n', '\t// ERC20 approve\n', '    function approve(address _spender, uint256 _value) public returns(bool success) {\n', '        revert();\n', '    }\n', '\n', '\t// ERC20 transferFrom\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {\n', '    \trevert();\n', '    }\n', '    \n', '    // Set start and stop blocks of poll\n', '    function setStartStopBlocks(uint256 _pStartBlock, uint256 _pStopBlock) public onlyOwner {\n', '    \tpStartBlock = _pStartBlock;\n', '    \tpStopBlock = _pStopBlock;\n', '    }\n', '    \n', '    // Withdraw\n', '    function withdrawToFounders(uint256 amount) public onlyOwner {\n', '    \tuint256 amount_to_withdraw = amount * 1000000000000000; // 0.001 ETH\n', '        if (this.balance < amount_to_withdraw) revert();\n', '        amount_to_withdraw = amount_to_withdraw / foundersAddresses.length;\n', '        uint8 i = 0;\n', '        uint8 errors = 0;\n', '        \n', '        for (i = 0; i < foundersAddresses.length; i++) {\n', '\t\t\tif (!foundersAddresses[i].send(amount_to_withdraw)) {\n', '\t\t\t\terrors++;\n', '\t\t\t}\n', '\t\t}\n', '    }\n', '    \n', '    function killPoll() public onlySuperOwner {\n', '    \tselfdestruct(foundersAddresses[0]);\n', '    }\n', '}']