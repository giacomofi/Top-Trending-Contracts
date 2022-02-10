['pragma solidity ^0.5.0;\n', '\n', 'contract Ownable {\n', '    address payable public owner;\n', '    constructor () public {owner = msg.sender;}\n', '    modifier onlyOwner() {require(msg.sender == owner, "Only owner can call");_;}\n', '    function transferOwnership(address payable newOwner) external onlyOwner {\n', '        if(newOwner != address(0)){owner = newOwner;}\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract RemiAirdrop is Ownable{\n', '    // Notify when contract deployed\n', '    event contractDeployed();\n', '    \n', '\n', '    // State Variable that affects to airdropToken function\n', '    address public SOURCE_ADDRESS;\n', '    uint public DEFAULT_AMOUNT;\n', '    IERC20 public REMI_INTERFACE;\n', '    \n', '\n', '    // Set state variables simultaneously with construct\n', '    constructor (address _tokenAddress, address _sourceAddress, uint _defaultAmount) public{\n', '        REMI_INTERFACE = IERC20(_tokenAddress);\n', '        SOURCE_ADDRESS = _sourceAddress;\n', '        DEFAULT_AMOUNT = _defaultAmount;\n', '        \n', '        emit contractDeployed();\n', '    }\n', '    \n', '    // Airdrop token from SOURCE_ADDRESS a _dropAmount per each _recipientList[i] via REMI_INTERFACE\n', '    function airdropToken(address[] calldata _recipientList, uint _dropAmount) external onlyOwner{\n', '        uint dropAmount = (_dropAmount > 0 ? _dropAmount : DEFAULT_AMOUNT) * 10**18;\n', '        require(_recipientList.length * dropAmount <= REMI_INTERFACE.allowance(SOURCE_ADDRESS,address(this)), "Allowed authority insufficient");\n', '        \n', '        for(uint i = 0; i < _recipientList.length; i++){\n', '            REMI_INTERFACE.transferFrom(SOURCE_ADDRESS, _recipientList[i], dropAmount);\n', '        }\n', '    }\n', '\n', '    // Set each state variable manually\n', '    function setTokenAddress(address _newToken) external onlyOwner{\n', '        REMI_INTERFACE = IERC20(_newToken);\n', '    }\n', '    function setSourceAddress(address _newSource) external onlyOwner{\n', '        SOURCE_ADDRESS = _newSource;\n', '    }\n', '    function setDefaultAmount(uint _newAmount) external onlyOwner{\n', '        DEFAULT_AMOUNT = _newAmount;\n', '    }\n', '\n', '    // Self destruct and refund balance to owner. need to send owners address to check once again\n', '    function _DESTROY_CONTRACT_(address _check) external onlyOwner{\n', '        require(_check == owner, "Enter owners address correctly");\n', '        selfdestruct(owner);\n', '    }\n', '}']