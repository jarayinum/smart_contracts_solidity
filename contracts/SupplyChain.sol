// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    // Enum to represent different stages in the supply chain
    enum Stage {
        Manufactured,
        Packaged,
        Shipped,
        Received,
        Sold
    }

    // Struct to store product details
    struct Product {
        uint id;
        string name;
        Stage currentStage;
        address currentOwner;
        uint timestamp;
        mapping(address => bool) authorizedParties;
    }

    // Mapping to store all products
    mapping(uint => Product) public products;
    uint public productCount;

    // Events for tracking
    event StageUpdated(uint indexed productId, Stage stage, address by, uint timestamp);
    event OwnershipTransferred(uint indexed productId, address from, address to);

    // Modifier to check authorized parties
    modifier onlyAuthorized(uint _productId) {
        require(products[_productId].authorizedParties[msg.sender], "Not authorized");
        _;
    }

    // Constructor - contract deployer is initially authorized
    constructor() {
        productCount = 0;
    }

    // Create a new product
    function createProduct(string memory _name) public returns (uint) {
        productCount++;
        
        Product storage newProduct = products[productCount];
        newProduct.id = productCount;
        newProduct.name = _name;
        newProduct.currentStage = Stage.Manufactured;
        newProduct.currentOwner = msg.sender;
        newProduct.timestamp = block.timestamp;
        newProduct.authorizedParties[msg.sender] = true;

        emit StageUpdated(productCount, Stage.Manufactured, msg.sender, block.timestamp);
        return productCount;
    }

    // Add authorized party
    function addAuthorizedParty(uint _productId, address _party) public {
        require(products[_productId].currentOwner == msg.sender, "Only owner can authorize");
        products[_productId].authorizedParties[_party] = true;
    }

    // Update product stage
    function updateStage(uint _productId, Stage _newStage) public onlyAuthorized(_productId) {
        require(_productId <= productCount && _productId > 0, "Invalid product ID");
        require(uint(_newStage) > uint(products[_productId].currentStage), "Can only move forward");
        
        products[_productId].currentStage = _newStage;
        products[_productId].timestamp = block.timestamp;
        
        emit StageUpdated(_productId, _newStage, msg.sender, block.timestamp);
    }

    // Transfer ownership
    function transferOwnership(uint _productId, address _newOwner) public onlyAuthorized(_productId) {
        require(products[_productId].currentOwner == msg.sender, "Only current owner can transfer");
        require(_newOwner != address(0), "Invalid new owner address");
        
        products[_productId].currentOwner = _newOwner;
        products[_productId].authorizedParties[_newOwner] = true;
        products[_productId].timestamp = block.timestamp;
        
        emit OwnershipTransferred(_productId, msg.sender, _newOwner);
    }

    // Get product details
    function getProductDetails(uint _productId) public view returns (
        uint id,
        string memory name,
        Stage currentStage,
        address currentOwner,
        uint timestamp
    ) {
        require(_productId <= productCount && _productId > 0, "Invalid product ID");
        
        Product storage product = products[_productId];
        return (
            product.id,
            product.name,
            product.currentStage,
            product.currentOwner,
            product.timestamp
        );
    }
}