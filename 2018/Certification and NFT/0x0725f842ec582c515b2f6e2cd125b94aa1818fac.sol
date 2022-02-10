['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title Ownable\n', '* @dev The Ownable contract has an owner address, and provides basic authorization control\n', '* functions, this simplifies the implementation of "user permissions".\n', '*/\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract BitmarkPaymentGateway is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event SettleFund(address _targetContract, uint256 amount);\n', '\n', '    address public masterWallet;\n', '    bool public paused;\n', '\n', '    /* main function */\n', '    function BitmarkPaymentGateway(address _masterWallet) public {\n', '        paused = false;\n', '        masterWallet = _masterWallet;\n', '    }\n', '\n', '    function SetMasterWallet(address _newWallet) public onlyOwner {\n', '        masterWallet = _newWallet;\n', '    }\n', '\n', '    function PausePayment() public onlyOwner {\n', '        paused = true;\n', '    }\n', '\n', '    function ResumePayment() public onlyOwner {\n', '        paused = false;\n', '    }\n', '\n', '    function Pay(address _destination) public payable {\n', '        require(_destination != 0x0);\n', '        require(msg.value > 0);\n', '        require(!paused);\n', '        masterWallet.transfer(msg.value.div(9));\n', '        _destination.call.value(msg.value.div(9).mul(8))();\n', '\n', '        SettleFund(_destination, msg.value);\n', '    }\n', '\n', '    function () public {}\n', '}']