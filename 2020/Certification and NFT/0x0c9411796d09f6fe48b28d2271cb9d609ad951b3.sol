['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-02\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract TrbInterface {\n', '    function getUintVar(bytes32 _data) view public returns(uint256);\n', '    function transfer(address _to, uint256 _amount) external returns (bool);\n', '    function depositStake() external;\n', '    function requestStakingWithdraw() external;\n', '    function withdrawStake() external;\n', '    function submitMiningSolution(string calldata _nonce,uint256[5] calldata _requestId, uint256[5] calldata _value) external;\n', '    function addTip(uint256 _requestId, uint256 _tip) external;\n', '}\n', '\n', 'contract Collection is Ownable {\n', '    \n', '    address createAddress;\n', '    address trbAddress = 0x0Ba45A8b5d5575935B8158a88C631E9F9C95a2e5;\n', '    \n', '    TrbInterface trbContract = TrbInterface(trbAddress);\n', '    \n', '    constructor() public {\n', '        createAddress = msg.sender;\n', '    }\n', '    \n', '    function() external onlyOwner payable{\n', '        require(createAddress == msg.sender, "author no");\n', '    }\n', '    \n', '    function finalize() external onlyOwner payable{\n', '        require(createAddress == msg.sender, "author no");\n', '    }\n', '    \n', '    function getCreate() public view returns(address){\n', '        return createAddress;\n', '    }\n', '    \n', '    //ETH\n', '    function withdrawEth(uint _amount) public onlyOwner payable{\n', '        require(createAddress == msg.sender, "author no");\n', '        msg.sender.transfer(_amount);\n', '    }\n', '    \n', '    function withdrawTrb(uint _amount) public onlyOwner payable{\n', '        require(createAddress == msg.sender, "author no");\n', '        trbContract.transfer(msg.sender, _amount);\n', '    }\n', '    \n', '    function depositStake() external onlyOwner payable{\n', '        require(createAddress == msg.sender, "author no");\n', '        trbContract.depositStake();\n', '    }\n', '    \n', '    function requestStakingWithdraw() external onlyOwner payable{\n', '        require(createAddress == msg.sender, "author no");\n', '        trbContract.requestStakingWithdraw();\n', '    }\n', '    \n', '    function withdrawStake() external onlyOwner payable{\n', '        require(createAddress == msg.sender, "author no");\n', '        trbContract.withdrawStake();\n', '    }\n', '    \n', '    function submitMiningSolution(string calldata _nonce, uint256[5] calldata _requestId, uint256[5] calldata _value) external onlyOwner payable{\n', '        require(createAddress == msg.sender, "author no");\n', '        \n', '        if (gasleft() <= 10**6){\n', '            bytes32 slotProgress =0x6c505cb2db6644f57b42d87bd9407b0f66788b07d0617a2bc1356a0e69e66f9a;\n', '            uint256 tmpSlot = trbContract.getUintVar(slotProgress);\n', '            require(tmpSlot < 4, "Z");\n', '        }\n', '        \n', '        trbContract.submitMiningSolution(_nonce, _requestId, _value);\n', '    }\n', '    \n', '    function addTip(uint256 _requestId, uint256 _tip) external onlyOwner payable{\n', '        require(createAddress == msg.sender, "author no");\n', '        trbContract.addTip(_requestId, _tip);\n', '    }\n', '    \n', '    function getUintVar(bytes32 _data) public onlyOwner view returns (uint256){\n', '        require(createAddress == msg.sender, "author no");\n', '        //bytes32 slotProgress =0x6c505cb2db6644f57b42d87bd9407b0f66788b07d0617a2bc1356a0e69e66f9a;\n', '        \n', '        return trbContract.getUintVar(_data);\n', '    }\n', '    \n', '}']