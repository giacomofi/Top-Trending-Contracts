['pragma solidity ^0.4.8;\n', '\n', '/*\n', 'This file is part of Pass DAO.\n', '\n', 'Pass DAO is free software: you can redistribute it and/or modify\n', 'it under the terms of the GNU lesser General Public License as published by\n', 'the Free Software Foundation, either version 3 of the License, or\n', '(at your option) any later version.\n', '\n', 'Pass DAO is distributed in the hope that it will be useful,\n', 'but WITHOUT ANY WARRANTY; without even the implied warranty of\n', 'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', 'GNU lesser General Public License for more details.\n', '\n', 'You should have received a copy of the GNU lesser General Public License\n', 'along with Pass DAO.  If not, see <http://www.gnu.org/licenses/>.\n', '*/\n', '\n', '/*\n', 'Smart contract for a Decentralized Autonomous Organization (DAO)\n', 'to automate organizational governance and decision-making.\n', '*/\n', '\n', '/// @title Pass Dao smart contract\n', 'contract PassDao {\n', '    \n', '    struct revision {\n', '        // Address of the Committee Room smart contract\n', '        address committeeRoom;\n', '        // Address of the share manager smart contract\n', '        address shareManager;\n', '        // Address of the token manager smart contract\n', '        address tokenManager;\n', '        // Address of the project creator smart contract\n', '        uint startDate;\n', '    }\n', '    // The revisions of the application until today\n', '    revision[] public revisions;\n', '\n', '    struct project {\n', '        // The address of the smart contract\n', '        address contractAddress;\n', '        // The unix effective start date of the contract\n', '        uint startDate;\n', '    }\n', '    // The projects of the Dao\n', '    project[] public projects;\n', '\n', '    // Map with the indexes of the projects\n', '    mapping (address => uint) projectID;\n', '    \n', '    // The address of the meta project\n', '    address metaProject;\n', '\n', '    \n', '// Events\n', '\n', '    event Upgrade(uint indexed RevisionID, address CommitteeRoom, address ShareManager, address TokenManager);\n', '    event NewProject(address Project);\n', '\n', '// Constant functions  \n', '    \n', '    /// @return The effective committee room\n', '    function ActualCommitteeRoom() constant returns (address) {\n', '        return revisions[0].committeeRoom;\n', '    }\n', '    \n', '    /// @return The meta project\n', '    function MetaProject() constant returns (address) {\n', '        return metaProject;\n', '    }\n', '\n', '    /// @return The effective share manager\n', '    function ActualShareManager() constant returns (address) {\n', '        return revisions[0].shareManager;\n', '    }\n', '\n', '    /// @return The effective token manager\n', '    function ActualTokenManager() constant returns (address) {\n', '        return revisions[0].tokenManager;\n', '    }\n', '\n', '// modifiers\n', '\n', '    modifier onlyPassCommitteeRoom {if (msg.sender != revisions[0].committeeRoom  \n', '        && revisions[0].committeeRoom != 0) throw; _;}\n', '    \n', '// Constructor function\n', '\n', '    function PassDao() {\n', '        projects.length = 1;\n', '        revisions.length = 1;\n', '    }\n', '    \n', '// Register functions\n', '\n', '    /// @dev Function to allow the actual Committee Room upgrading the application\n', '    /// @param _newCommitteeRoom The address of the new committee room\n', '    /// @param _newShareManager The address of the new share manager\n', '    /// @param _newTokenManager The address of the new token manager\n', '    /// @return The index of the revision\n', '    function upgrade(\n', '        address _newCommitteeRoom, \n', '        address _newShareManager, \n', '        address _newTokenManager) onlyPassCommitteeRoom returns (uint) {\n', '        \n', '        uint _revisionID = revisions.length++;\n', '        revision r = revisions[_revisionID];\n', '\n', '        if (_newCommitteeRoom != 0) r.committeeRoom = _newCommitteeRoom; else r.committeeRoom = revisions[0].committeeRoom;\n', '        if (_newShareManager != 0) r.shareManager = _newShareManager; else r.shareManager = revisions[0].shareManager;\n', '        if (_newTokenManager != 0) r.tokenManager = _newTokenManager; else r.tokenManager = revisions[0].tokenManager;\n', '\n', '        r.startDate = now;\n', '        \n', '        revisions[0] = r;\n', '        \n', '        Upgrade(_revisionID, _newCommitteeRoom, _newShareManager, _newTokenManager);\n', '            \n', '        return _revisionID;\n', '    }\n', '\n', '    /// @dev Function to set the meta project\n', '    /// @param _projectAddress The address of the meta project\n', '    function addMetaProject(address _projectAddress) onlyPassCommitteeRoom {\n', '\n', '        metaProject = _projectAddress;\n', '    }\n', '    \n', '    /// @dev Function to allow the committee room to add a project when ordering\n', '    /// @param _projectAddress The address of the project\n', '    function addProject(address _projectAddress) onlyPassCommitteeRoom {\n', '\n', '        if (projectID[_projectAddress] == 0) {\n', '\n', '            uint _projectID = projects.length++;\n', '            project p = projects[_projectID];\n', '        \n', '            projectID[_projectAddress] = _projectID;\n', '            p.contractAddress = _projectAddress; \n', '            p.startDate = now;\n', '            \n', '            NewProject(_projectAddress);\n', '        }\n', '    }\n', '    \n', '}\n', '\n', 'pragma solidity ^0.4.8;\n', '\n', '/*\n', ' *\n', ' * This file is part of Pass DAO.\n', ' *\n', ' * The Project smart contract is used for the management of the Pass Dao projects.\n', ' *\n', '*/\n', '\n', '/// @title Project smart contract of the Pass Decentralized Autonomous Organisation\n', 'contract PassProject {\n', '\n', '    // The Pass Dao smart contract\n', '    PassDao public passDao;\n', '    \n', '    // The project name\n', '    string public name;\n', '    // The project description\n', '    string public description;\n', '    // The Hash Of the project Document\n', '    bytes32 public hashOfTheDocument;\n', '    // The project manager smart contract\n', '    address projectManager;\n', '\n', '    struct order {\n', '        // The address of the contractor smart contract\n', '        address contractorAddress;\n', '        // The index of the contractor proposal\n', '        uint contractorProposalID;\n', '        // The amount of the order\n', '        uint amount;\n', '        // The date of the order\n', '        uint orderDate;\n', '    }\n', '    // The orders of the Dao for this project\n', '    order[] public orders;\n', '    \n', '    // The total amount of orders in wei for this project\n', '    uint public totalAmountOfOrders;\n', '\n', '    struct resolution {\n', '        // The name of the resolution\n', '        string name;\n', '        // A description of the resolution\n', '        string description;\n', '        // The date of the resolution\n', '        uint creationDate;\n', '    }\n', '    // Resolutions of the Dao for this project\n', '    resolution[] public resolutions;\n', '    \n', '// Events\n', '\n', '    event OrderAdded(address indexed Client, address indexed ContractorAddress, uint indexed ContractorProposalID, uint Amount, uint OrderDate);\n', '    event ProjectDescriptionUpdated(address indexed By, string NewDescription, bytes32 NewHashOfTheDocument);\n', '    event ResolutionAdded(address indexed Client, uint indexed ResolutionID, string Name, string Description);\n', '\n', '// Constant functions  \n', '\n', '    /// @return the actual committee room of the Dao   \n', '    function Client() constant returns (address) {\n', '        return passDao.ActualCommitteeRoom();\n', '    }\n', '    \n', '    /// @return The number of orders \n', '    function numberOfOrders() constant returns (uint) {\n', '        return orders.length - 1;\n', '    }\n', '    \n', '    /// @return The project Manager address\n', '    function ProjectManager() constant returns (address) {\n', '        return projectManager;\n', '    }\n', '\n', '    /// @return The number of resolutions \n', '    function numberOfResolutions() constant returns (uint) {\n', '        return resolutions.length - 1;\n', '    }\n', '    \n', '// modifiers\n', '\n', '    // Modifier for project manager functions \n', '    modifier onlyProjectManager {if (msg.sender != projectManager) throw; _;}\n', '\n', '    // Modifier for the Dao functions \n', '    modifier onlyClient {if (msg.sender != Client()) throw; _;}\n', '\n', '// Constructor function\n', '\n', '    function PassProject(\n', '        PassDao _passDao, \n', '        string _name,\n', '        string _description,\n', '        bytes32 _hashOfTheDocument) {\n', '\n', '        passDao = _passDao;\n', '        name = _name;\n', '        description = _description;\n', '        hashOfTheDocument = _hashOfTheDocument;\n', '        \n', '        orders.length = 1;\n', '        resolutions.length = 1;\n', '    }\n', '    \n', '// Internal functions\n', '\n', '    /// @dev Internal function to register a new order\n', '    /// @param _contractorAddress The address of the contractor smart contract\n', '    /// @param _contractorProposalID The index of the contractor proposal\n', '    /// @param _amount The amount in wei of the order\n', '    /// @param _orderDate The date of the order \n', '    function addOrder(\n', '\n', '        address _contractorAddress, \n', '        uint _contractorProposalID, \n', '        uint _amount, \n', '        uint _orderDate) internal {\n', '\n', '        uint _orderID = orders.length++;\n', '        order d = orders[_orderID];\n', '        d.contractorAddress = _contractorAddress;\n', '        d.contractorProposalID = _contractorProposalID;\n', '        d.amount = _amount;\n', '        d.orderDate = _orderDate;\n', '        \n', '        totalAmountOfOrders += _amount;\n', '        \n', '        OrderAdded(msg.sender, _contractorAddress, _contractorProposalID, _amount, _orderDate);\n', '    }\n', '    \n', '// Setting functions\n', '\n', '    /// @notice Function to allow cloning orders in case of upgrade\n', '    /// @param _contractorAddress The address of the contractor smart contract\n', '    /// @param _contractorProposalID The index of the contractor proposal\n', '    /// @param _orderAmount The amount in wei of the order\n', '    /// @param _lastOrderDate The unix date of the last order \n', '    function cloneOrder(\n', '        address _contractorAddress, \n', '        uint _contractorProposalID, \n', '        uint _orderAmount, \n', '        uint _lastOrderDate) {\n', '        \n', '        if (projectManager != 0) throw;\n', '        \n', '        addOrder(_contractorAddress, _contractorProposalID, _orderAmount, _lastOrderDate);\n', '    }\n', '    \n', '    /// @notice Function to set the project manager\n', '    /// @param _projectManager The address of the project manager smart contract\n', '    /// @return True if successful\n', '    function setProjectManager(address _projectManager) returns (bool) {\n', '\n', '        if (_projectManager == 0 || projectManager != 0) return;\n', '        \n', '        projectManager = _projectManager;\n', '        \n', '        return true;\n', '    }\n', '\n', '// Project manager functions\n', '\n', '    /// @notice Function to allow the project manager updating the description of the project\n', '    /// @param _projectDescription A description of the project\n', '    /// @param _hashOfTheDocument The hash of the last document\n', '    function updateDescription(string _projectDescription, bytes32 _hashOfTheDocument) onlyProjectManager {\n', '        description = _projectDescription;\n', '        hashOfTheDocument = _hashOfTheDocument;\n', '        ProjectDescriptionUpdated(msg.sender, _projectDescription, _hashOfTheDocument);\n', '    }\n', '\n', '// Client functions\n', '\n', '    /// @dev Function to allow the Dao to register a new order\n', '    /// @param _contractorAddress The address of the contractor smart contract\n', '    /// @param _contractorProposalID The index of the contractor proposal\n', '    /// @param _amount The amount in wei of the order\n', '    function newOrder(\n', '        address _contractorAddress, \n', '        uint _contractorProposalID, \n', '        uint _amount) onlyClient {\n', '            \n', '        addOrder(_contractorAddress, _contractorProposalID, _amount, now);\n', '    }\n', '    \n', '    /// @dev Function to allow the Dao to register a new resolution\n', '    /// @param _name The name of the resolution\n', '    /// @param _description The description of the resolution\n', '    function newResolution(\n', '        string _name, \n', '        string _description) onlyClient {\n', '\n', '        uint _resolutionID = resolutions.length++;\n', '        resolution d = resolutions[_resolutionID];\n', '        \n', '        d.name = _name;\n', '        d.description = _description;\n', '        d.creationDate = now;\n', '\n', '        ResolutionAdded(msg.sender, _resolutionID, d.name, d.description);\n', '    }\n', '}\n', '\n', 'contract PassProjectCreator {\n', '    \n', '    event NewPassProject(PassDao indexed Dao, PassProject indexed Project, string Name, string Description, bytes32 HashOfTheDocument);\n', '\n', '    /// @notice Function to create a new Pass project\n', '    /// @param _passDao The Pass Dao smart contract\n', '    /// @param _name The project name\n', '    /// @param _description The project description (not mandatory, can be updated after by the creator)\n', '    /// @param _hashOfTheDocument The Hash Of the project Document (not mandatory, can be updated after by the creator)\n', '    function createProject(\n', '        PassDao _passDao,\n', '        string _name, \n', '        string _description, \n', '        bytes32 _hashOfTheDocument\n', '        ) returns (PassProject) {\n', '\n', '        PassProject _passProject = new PassProject(_passDao, _name, _description, _hashOfTheDocument);\n', '\n', '        NewPassProject(_passDao, _passProject, _name, _description, _hashOfTheDocument);\n', '\n', '        return _passProject;\n', '    }\n', '}\n', '    \n', '\n', 'pragma solidity ^0.4.8;\n', '\n', '/*\n', ' *\n', ' * This file is part of Pass DAO.\n', ' *\n', ' * The Project smart contract is used for the management of the Pass Dao projects.\n', ' *\n', '*/\n', '\n', '/// @title Contractor smart contract of the Pass Decentralized Autonomous Organisation\n', 'contract PassContractor {\n', '    \n', '    // The project smart contract\n', '    PassProject passProject;\n', '    \n', '    // The address of the creator of this smart contract\n', '    address public creator;\n', '    // Address of the recipient;\n', '    address public recipient;\n', '\n', '    // End date of the setup procedure\n', '    uint public smartContractStartDate;\n', '\n', '    struct proposal {\n', '        // Amount (in wei) of the proposal\n', '        uint amount;\n', '        // A description of the proposal\n', '        string description;\n', "        // The hash of the proposal's document\n", '        bytes32 hashOfTheDocument;\n', '        // A unix timestamp, denoting the date when the proposal was created\n', '        uint dateOfProposal;\n', '        // The amount submitted to a vote\n', '        uint submittedAmount;\n', '        // The sum amount (in wei) ordered for this proposal \n', '        uint orderAmount;\n', '        // A unix timestamp, denoting the date of the last order for the approved proposal\n', '        uint dateOfLastOrder;\n', '    }\n', '    // Proposals to work for Pass Dao\n', '    proposal[] public proposals;\n', '\n', '// Events\n', '\n', '    event RecipientUpdated(address indexed By, address LastRecipient, address NewRecipient);\n', '    event Withdrawal(address indexed By, address indexed Recipient, uint Amount);\n', '    event ProposalAdded(address Creator, uint indexed ProposalID, uint Amount, string Description, bytes32 HashOfTheDocument);\n', '    event ProposalSubmitted(address indexed Client, uint Amount);\n', '    event Order(address indexed Client, uint indexed ProposalID, uint Amount);\n', '\n', '// Constant functions\n', '\n', '    /// @return the actual committee room of the Dao\n', '    function Client() constant returns (address) {\n', '        return passProject.Client();\n', '    }\n', '\n', '    /// @return the project smart contract\n', '    function Project() constant returns (PassProject) {\n', '        return passProject;\n', '    }\n', '    \n', '    /// @notice Function used by the client to check the proposal before submitting\n', '    /// @param _sender The creator of the Dao proposal\n', '    /// @param _proposalID The index of the proposal\n', '    /// @param _amount The amount of the proposal\n', '    /// @return true if the proposal can be submitted\n', '    function proposalChecked(\n', '        address _sender,\n', '        uint _proposalID, \n', '        uint _amount) constant external onlyClient returns (bool) {\n', '        if (_sender != recipient && _sender != creator) return;\n', '        if (_amount <= proposals[_proposalID].amount - proposals[_proposalID].submittedAmount) return true;\n', '    }\n', '\n', '    /// @return The number of proposals     \n', '    function numberOfProposals() constant returns (uint) {\n', '        return proposals.length - 1;\n', '    }\n', '\n', '\n', '// Modifiers\n', '\n', '    // Modifier for contractor functions\n', '    modifier onlyContractor {if (msg.sender != recipient) throw; _;}\n', '    \n', '    // Modifier for client functions\n', '    modifier onlyClient {if (msg.sender != Client()) throw; _;}\n', '\n', '// Constructor function\n', '\n', '    function PassContractor(\n', '        address _creator, \n', '        PassProject _passProject, \n', '        address _recipient,\n', '        bool _restore) { \n', '\n', '        if (address(_passProject) == 0) throw;\n', '        \n', '        creator = _creator;\n', '        if (_recipient == 0) _recipient = _creator;\n', '        recipient = _recipient;\n', '        \n', '        passProject = _passProject;\n', '        \n', '        if (!_restore) smartContractStartDate = now;\n', '\n', '        proposals.length = 1;\n', '    }\n', '\n', '// Setting functions\n', '\n', '    /// @notice Function to clone a proposal from the last contractor\n', '    /// @param _amount Amount (in wei) of the proposal\n', '    /// @param _description A description of the proposal\n', "    /// @param _hashOfTheDocument The hash of the proposal's document\n", '    /// @param _dateOfProposal A unix timestamp, denoting the date when the proposal was created\n', '    /// @param _orderAmount The sum amount (in wei) ordered for this proposal \n', '    /// @param _dateOfOrder A unix timestamp, denoting the date of the last order for the approved proposal\n', '    /// @param _cloneOrder True if the order has to be cloned in the project smart contract\n', '    /// @return Whether the function was successful or not \n', '    function cloneProposal(\n', '        uint _amount,\n', '        string _description,\n', '        bytes32 _hashOfTheDocument,\n', '        uint _dateOfProposal,\n', '        uint _orderAmount,\n', '        uint _dateOfOrder,\n', '        bool _cloneOrder\n', '    ) returns (bool success) {\n', '            \n', '        if (smartContractStartDate != 0 || recipient == 0\n', '        || msg.sender != creator) throw;\n', '        \n', '        uint _proposalID = proposals.length++;\n', '        proposal c = proposals[_proposalID];\n', '\n', '        c.amount = _amount;\n', '        c.description = _description;\n', '        c.hashOfTheDocument = _hashOfTheDocument; \n', '        c.dateOfProposal = _dateOfProposal;\n', '        c.orderAmount = _orderAmount;\n', '        c.dateOfLastOrder = _dateOfOrder;\n', '\n', '        ProposalAdded(msg.sender, _proposalID, _amount, _description, _hashOfTheDocument);\n', '        \n', '        if (_cloneOrder) passProject.cloneOrder(address(this), _proposalID, _orderAmount, _dateOfOrder);\n', '        \n', '        return true;\n', '    }\n', '\n', '    /// @notice Function to close the setting procedure and start to use this smart contract\n', '    /// @return True if successful\n', '    function closeSetup() returns (bool) {\n', '        \n', '        if (smartContractStartDate != 0 \n', '            || (msg.sender != creator && msg.sender != Client())) return;\n', '\n', '        smartContractStartDate = now;\n', '\n', '        return true;\n', '    }\n', '    \n', '// Account Management\n', '\n', '    /// @notice Function to update the recipent address\n', '    /// @param _newRecipient The adress of the recipient\n', '    function updateRecipient(address _newRecipient) onlyContractor {\n', '\n', '        if (_newRecipient == 0) throw;\n', '\n', '        RecipientUpdated(msg.sender, recipient, _newRecipient);\n', '        recipient = _newRecipient;\n', '    } \n', '\n', '    /// @notice Function to receive payments\n', '    function () payable { }\n', '    \n', '    /// @notice Function to allow contractors to withdraw ethers\n', '    /// @param _amount The amount (in wei) to withdraw\n', '    function withdraw(uint _amount) onlyContractor {\n', '        if (!recipient.send(_amount)) throw;\n', '        Withdrawal(msg.sender, recipient, _amount);\n', '    }\n', '    \n', '// Project Manager Functions    \n', '\n', '    /// @notice Function to allow the project manager updating the description of the project\n', '    /// @param _projectDescription A description of the project\n', '    /// @param _hashOfTheDocument The hash of the last document\n', '    function updateProjectDescription(string _projectDescription, bytes32 _hashOfTheDocument) onlyContractor {\n', '        passProject.updateDescription(_projectDescription, _hashOfTheDocument);\n', '    }\n', '    \n', '// Management of proposals\n', '\n', '    /// @notice Function to make a proposal to work for the client\n', '    /// @param _creator The address of the creator of the proposal\n', '    /// @param _amount The amount (in wei) of the proposal\n', '    /// @param _description String describing the proposal\n', '    /// @param _hashOfTheDocument The hash of the proposal document\n', '    /// @return The index of the contractor proposal\n', '    function newProposal(\n', '        address _creator,\n', '        uint _amount,\n', '        string _description, \n', '        bytes32 _hashOfTheDocument\n', '    ) external returns (uint) {\n', '        \n', '        if (msg.sender == Client() && _creator != recipient && _creator != creator) throw;\n', '        if (msg.sender != Client() && msg.sender != recipient && msg.sender != creator) throw;\n', '\n', '        if (_amount == 0) throw;\n', '        \n', '        uint _proposalID = proposals.length++;\n', '        proposal c = proposals[_proposalID];\n', '\n', '        c.amount = _amount;\n', '        c.description = _description;\n', '        c.hashOfTheDocument = _hashOfTheDocument; \n', '        c.dateOfProposal = now;\n', '        \n', '        ProposalAdded(msg.sender, _proposalID, c.amount, c.description, c.hashOfTheDocument);\n', '        \n', '        return _proposalID;\n', '    }\n', '    \n', '    /// @notice Function used by the client to infor about the submitted amount\n', '    /// @param _sender The address of the sender who submits the proposal\n', '    /// @param _proposalID The index of the contractor proposal\n', '    /// @param _amount The amount (in wei) submitted\n', '    function submitProposal(\n', '        address _sender, \n', '        uint _proposalID, \n', '        uint _amount) onlyClient {\n', '\n', '        if (_sender != recipient && _sender != creator) throw;    \n', '        proposals[_proposalID].submittedAmount += _amount;\n', '        ProposalSubmitted(msg.sender, _amount);\n', '    }\n', '\n', '    /// @notice Function used by the client to order according to the contractor proposal\n', '    /// @param _proposalID The index of the contractor proposal\n', '    /// @param _orderAmount The amount (in wei) of the order\n', '    /// @return Whether the order was made or not\n', '    function order(\n', '        uint _proposalID,\n', '        uint _orderAmount\n', '    ) external onlyClient returns (bool) {\n', '    \n', '        proposal c = proposals[_proposalID];\n', '        \n', '        uint _sum = c.orderAmount + _orderAmount;\n', '        if (_sum > c.amount\n', '            || _sum < c.orderAmount\n', '            || _sum < _orderAmount) return; \n', '\n', '        c.orderAmount = _sum;\n', '        c.dateOfLastOrder = now;\n', '        \n', '        Order(msg.sender, _proposalID, _orderAmount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '}\n', '\n', 'contract PassContractorCreator {\n', '    \n', '    // Address of the pass Dao smart contract\n', '    PassDao public passDao;\n', '    // Address of the Pass Project creator\n', '    PassProjectCreator public projectCreator;\n', '    \n', '    struct contractor {\n', '        // The address of the creator of the contractor\n', '        address creator;\n', '        // The contractor smart contract\n', '        PassContractor contractor;\n', '        // The address of the recipient for withdrawals\n', '        address recipient;\n', '        // True if meta project\n', '        bool metaProject;\n', '        // The address of the existing project smart contract\n', '        PassProject passProject;\n', "        // The name of the project (if the project smart contract doesn't exist)\n", '        string projectName;\n', '        // A description of the project (can be updated after)\n', '        string projectDescription;\n', '        // The unix creation date of the contractor\n', '        uint creationDate;\n', '    }\n', '    // contractors created to work for Pass Dao\n', '    contractor[] public contractors;\n', '    \n', '    event NewPassContractor(address indexed Creator, address indexed Recipient, PassProject indexed Project, PassContractor Contractor);\n', '\n', '    function PassContractorCreator(PassDao _passDao, PassProjectCreator _projectCreator) {\n', '        passDao = _passDao;\n', '        projectCreator = _projectCreator;\n', '        contractors.length = 0;\n', '    }\n', '\n', '    /// @return The number of created contractors \n', '    function numberOfContractors() constant returns (uint) {\n', '        return contractors.length;\n', '    }\n', '    \n', '    /// @notice Function to create a contractor smart contract\n', '    /// @param _creator The address of the creator of the contractor\n', '    /// @param _recipient The address of the recipient for withdrawals\n', '    /// @param _metaProject True if meta project\n', '    /// @param _passProject The address of the existing project smart contract\n', "    /// @param _projectName The name of the project (if the project smart contract doesn't exist)\n", '    /// @param _projectDescription A description of the project (can be updated after)\n', '    /// @param _restore True if orders or proposals are to be cloned from other contracts\n', '    /// @return The address of the created contractor smart contract\n', '    function createContractor(\n', '        address _creator,\n', '        address _recipient, \n', '        bool _metaProject,\n', '        PassProject _passProject,\n', '        string _projectName, \n', '        string _projectDescription,\n', '        bool _restore) returns (PassContractor) {\n', ' \n', '        PassProject _project;\n', '\n', '        if (_creator == 0) _creator = msg.sender;\n', '        \n', '        if (_metaProject) _project = PassProject(passDao.MetaProject());\n', '        else if (address(_passProject) == 0) \n', '            _project = projectCreator.createProject(passDao, _projectName, _projectDescription, 0);\n', '        else _project = _passProject;\n', '\n', '        PassContractor _contractor = new PassContractor(_creator, _project, _recipient, _restore);\n', '        if (!_metaProject && address(_passProject) == 0 && !_restore) _project.setProjectManager(address(_contractor));\n', '        \n', '        uint _contractorID = contractors.length++;\n', '        contractor c = contractors[_contractorID];\n', '        c.creator = _creator;\n', '        c.contractor = _contractor;\n', '        c.recipient = _recipient;\n', '        c.metaProject = _metaProject;\n', '        c.passProject = _passProject;\n', '        c.projectName = _projectName;\n', '        c.projectDescription = _projectDescription;\n', '        c.creationDate = now;\n', '\n', '        NewPassContractor(_creator, _recipient, _project, _contractor);\n', ' \n', '        return _contractor;\n', '    }\n', '    \n', '}']