['/*\n', '██╗     ███████╗██╗  ██╗    \n', '██║     ██╔════╝╚██╗██╔╝    \n', '██║     █████╗   ╚███╔╝     \n', '██║     ██╔══╝   ██╔██╗     \n', '███████╗███████╗██╔╝ ██╗    \n', '╚══════╝╚══════╝╚═╝  ╚═╝    \n', '██╗     ██╗███████╗████████╗\n', '██║     ██║██╔════╝╚══██╔══╝\n', '██║     ██║███████╗   ██║   \n', '██║     ██║╚════██║   ██║   \n', '███████╗██║███████║   ██║   \n', '╚══════╝╚═╝╚══════╝   ╚═╝*/\n', 'pragma solidity 0.5.17;\n', '\n', 'contract LexList {\n', '    address public governance;\n', '    address[] private listings;\n', '    string public message;\n', '    mapping(address => Contract) private contractList;\n', '    \n', '    event List(address indexed _contract);\n', '    event Delist(address indexed _contract);\n', '    event UpdateGovernance(address indexed governance);\n', '    event UpdateMessage(string indexed message);\n', '    \n', '    struct Contract {\n', '        uint256 contractIndex;\n', '        bool listed;\n', '    }\n', '    \n', '    constructor (address[] memory _contract, address _governance, string memory _message) public {\n', '        for (uint256 i = 0; i < _contract.length; i++) {\n', '            contractList[_contract[i]].contractIndex = listings.push(_contract[i]) - 1;\n', '            contractList[_contract[i]].listed = true;\n', '        }\n', '        \n', '        governance = _governance;\n', '        message = _message;\n', '    }\n', '    \n', '    modifier onlyGovernance {\n', '        require(msg.sender == governance, "!governance");\n', '        _;\n', '    }\n', '    \n', '    /****************\n', '    LISTING FUNCTIONS\n', '    ****************/\n', '    function delist(address[] calldata _contract) external onlyGovernance {\n', '        for (uint256 i = 0; i < _contract.length; i++) {\n', '            require(contractList[_contract[i]].listed, "!listed");\n', '            \n', '            uint256 contractToUnlist = contractList[_contract[i]].contractIndex;\n', '            address k = listings[listings.length - 1];\n', '            listings[contractToUnlist] = k;\n', '            contractList[k].contractIndex = contractToUnlist;\n', '            contractList[_contract[i]].listed = false;\n', '            listings.length--;\n', '            \n', '            emit Delist(_contract[i]);\n', '        }\n', '    }\n', '    \n', '    function list(address[] calldata _contract) external onlyGovernance { \n', '        for (uint256 i = 0; i < _contract.length; i++) {\n', '            require(!contractList[_contract[i]].listed, "listed");\n', '            \n', '            contractList[_contract[i]].contractIndex = listings.push(_contract[i]) - 1;\n', '            contractList[_contract[i]].listed = true;\n', '            \n', '            emit List(_contract[i]);\n', '        }\n', '    }\n', '    \n', '    function updateGovernance(address _governance) external onlyGovernance {\n', '        governance = _governance;\n', '        \n', '        emit UpdateGovernance(governance);\n', '    }\n', '    \n', '    function updateMessage(string calldata _message) external onlyGovernance {\n', '        message = _message;\n', '        \n', '        emit UpdateMessage(message);\n', '    }\n', '    \n', '    // *******\n', '    // GETTERS\n', '    // *******\n', '    function contractCount() external view returns (uint256) {\n', '        return listings.length;\n', '    }\n', '    \n', '    function isListed(address _contract) external view returns (bool) {\n', '        if(listings.length == 0) return false;\n', '        return (listings[contractList[_contract].contractIndex] == _contract);\n', '    }\n', '}']