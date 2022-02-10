['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-01\n', '*/\n', '\n', '// File: contracts/lib/CloneFactory.sol\n', '\n', '/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '    SPDX-License-Identifier: Apache-2.0\n', '\n', '*/\n', '\n', 'pragma solidity 0.6.9;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface ICloneFactory {\n', '    function clone(address prototype) external returns (address proxy);\n', '}\n', '\n', '// introduction of proxy mode design: https://docs.openzeppelin.com/upgrades/2.8/\n', '// minimum implementation of transparent proxy: https://eips.ethereum.org/EIPS/eip-1167\n', '\n', 'contract CloneFactory is ICloneFactory {\n', '    function clone(address prototype) external override returns (address proxy) {\n', '        bytes20 targetBytes = bytes20(prototype);\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)\n', '            mstore(add(clone, 0x14), targetBytes)\n', '            mstore(\n', '                add(clone, 0x28),\n', '                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000\n', '            )\n', '            proxy := create(0, clone, 0x37)\n', '        }\n', '        return proxy;\n', '    }\n', '}\n', '\n', '// File: contracts/lib/InitializableOwnable.sol\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Ownership related functions\n', ' */\n', 'contract InitializableOwnable {\n', '    address public _OWNER_;\n', '    address public _NEW_OWNER_;\n', '    bool internal _INITIALIZED_;\n', '\n', '    // ============ Events ============\n', '\n', '    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    // ============ Modifiers ============\n', '\n', '    modifier notInitialized() {\n', '        require(!_INITIALIZED_, "DODO_INITIALIZED");\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _OWNER_, "NOT_OWNER");\n', '        _;\n', '    }\n', '\n', '    // ============ Functions ============\n', '\n', '    function initOwner(address newOwner) public notInitialized {\n', '        _INITIALIZED_ = true;\n', '        _OWNER_ = newOwner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        emit OwnershipTransferPrepared(_OWNER_, newOwner);\n', '        _NEW_OWNER_ = newOwner;\n', '    }\n', '\n', '    function claimOwnership() public {\n', '        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");\n', '        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);\n', '        _OWNER_ = _NEW_OWNER_;\n', '        _NEW_OWNER_ = address(0);\n', '    }\n', '}\n', '\n', '// File: contracts/Factory/ERC20V2Factory.sol\n', '\n', '\n', 'interface IStdERC20 {\n', '    function init(\n', '        address _creator,\n', '        uint256 _totalSupply,\n', '        string memory _name,\n', '        string memory _symbol,\n', '        uint8 _decimals\n', '    ) external;\n', '}\n', '\n', 'interface ICustomERC20 {\n', '    function init(\n', '        address _creator,\n', '        uint256 _initSupply,\n', '        string memory _name,\n', '        string memory _symbol,\n', '        uint8 _decimals,\n', '        uint256 _tradeBurnRatio,\n', '        uint256 _tradeFeeRatio,\n', '        address _team,\n', '        bool _isMintable\n', '    ) external;\n', '}\n', '\n', '/**\n', ' * @title DODO ERC20V2Factory\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Help user to create erc20 token\n', ' */\n', 'contract ERC20V2Factory is InitializableOwnable {\n', '    // ============ Templates ============\n', '\n', '    address public immutable _CLONE_FACTORY_;\n', '    address public _ERC20_TEMPLATE_;\n', '    address public _CUSTOM_ERC20_TEMPLATE_;\n', '    uint256 public _CREATE_FEE_;\n', '\n', '    // ============ Events ============\n', '    // 0 Std 1 TradeBurn or TradeFee 2 Mintable\n', '    event NewERC20(address erc20, address creator, uint256 erc20Type);\n', '    event ChangeCreateFee(uint256 newFee);\n', '    event Withdraw(address account, uint256 amount);\n', '    event ChangeStdTemplate(address newStdTemplate);\n', '    event ChangeCustomTemplate(address newCustomTemplate);\n', '\n', '    // ============ Registry ============\n', '    // creator -> token address list\n', '    mapping(address => address[]) public _USER_STD_REGISTRY_;\n', '    mapping(address => address[]) public _USER_CUSTOM_REGISTRY_;\n', '\n', '    // ============ Functions ============\n', '\n', '    fallback() external payable {}\n', '\n', '    receive() external payable {}\n', '\n', '    constructor(\n', '        address cloneFactory,\n', '        address erc20Template,\n', '        address customErc20Template\n', '    ) public {\n', '        _CLONE_FACTORY_ = cloneFactory;\n', '        _ERC20_TEMPLATE_ = erc20Template;\n', '        _CUSTOM_ERC20_TEMPLATE_ = customErc20Template;\n', '    }\n', '\n', '    function createStdERC20(\n', '        uint256 totalSupply,\n', '        string memory name,\n', '        string memory symbol,\n', '        uint8 decimals\n', '    ) external payable returns (address newERC20) {\n', '        require(msg.value >= _CREATE_FEE_, "CREATE_FEE_NOT_ENOUGH");\n', '        newERC20 = ICloneFactory(_CLONE_FACTORY_).clone(_ERC20_TEMPLATE_);\n', '        IStdERC20(newERC20).init(msg.sender, totalSupply, name, symbol, decimals);\n', '        _USER_STD_REGISTRY_[msg.sender].push(newERC20);\n', '        emit NewERC20(newERC20, msg.sender, 0);\n', '    }\n', '\n', '    function createCustomERC20(\n', '        uint256 initSupply,\n', '        string memory name,\n', '        string memory symbol,\n', '        uint8 decimals,\n', '        uint256 tradeBurnRatio,\n', '        uint256 tradeFeeRatio,\n', '        address teamAccount,\n', '        bool isMintable\n', '    ) external payable returns (address newCustomERC20) {\n', '        require(msg.value >= _CREATE_FEE_, "CREATE_FEE_NOT_ENOUGH");\n', '        newCustomERC20 = ICloneFactory(_CLONE_FACTORY_).clone(_CUSTOM_ERC20_TEMPLATE_);\n', '\n', '        ICustomERC20(newCustomERC20).init(\n', '            msg.sender,\n', '            initSupply, \n', '            name, \n', '            symbol, \n', '            decimals, \n', '            tradeBurnRatio, \n', '            tradeFeeRatio,\n', '            teamAccount,\n', '            isMintable\n', '        );\n', '\n', '        _USER_CUSTOM_REGISTRY_[msg.sender].push(newCustomERC20);\n', '        if(isMintable)\n', '            emit NewERC20(newCustomERC20, msg.sender, 2);\n', '        else \n', '            emit NewERC20(newCustomERC20, msg.sender, 1);\n', '    }\n', '\n', '\n', '    // ============ View ============\n', '    function getTokenByUser(address user) \n', '        external\n', '        view\n', '        returns (address[] memory stds,address[] memory customs)\n', '    {\n', '        return (_USER_STD_REGISTRY_[user], _USER_CUSTOM_REGISTRY_[user]);\n', '    }\n', '\n', '    // ============ Ownable =============\n', '    function changeCreateFee(uint256 newFee) external onlyOwner {\n', '        _CREATE_FEE_ = newFee;\n', '        emit ChangeCreateFee(newFee);\n', '    }\n', '\n', '    function withdraw() external onlyOwner {\n', '        uint256 amount = address(this).balance;\n', '        msg.sender.transfer(amount);\n', '        emit Withdraw(msg.sender, amount);\n', '    }\n', '\n', '    function updateStdTemplate(address newStdTemplate) external onlyOwner {\n', '        _ERC20_TEMPLATE_ = newStdTemplate;\n', '        emit ChangeStdTemplate(newStdTemplate);\n', '    }\n', '\n', '    function updateCustomTemplate(address newCustomTemplate) external onlyOwner {\n', '        _CUSTOM_ERC20_TEMPLATE_ = newCustomTemplate;\n', '        emit ChangeCustomTemplate(newCustomTemplate);\n', '    }\n', '}']