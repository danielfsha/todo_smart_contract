# Basic Sample TodoList Project

The contract is a simple todo-list management system. It allows the owner of the contract to create, update, and toggle the completion state of tasks (todos). It also allows querying of tasks by their completion status and owner.

The contract defines a struct called `Todo` that represents a todo item. It has an id, owner, content, and a boolean that indicates whether it's completed. The contract also has a state variable `owner` that stores the contract's owner address, a `name` for the todo list, and a counter `_todosCounter` to keep track of the total number of todos. Todos are stored in a public mapping `allTodos` that maps a uint (the todo id) to a `Todo` struct.

```shell
address public owner;
string public name;

uint private _todosCounter;

struct Todo {
    uint id;
    address owner;
    string content;
    bool isCompleted;
}

constructor(string memory _name) {
    name = _name;
    owner = msg.sender;
    _todosCounter = 0;
}
```
The constructor is called when the contract is deployed. It sets the `name` of the todo list and the `owner` of the contract to the address that deploys the contract. It also initializes `_todosCounter` to 0.

The contract emits events when a todo is created (`TodoCreated`), updated (`TodoUpdated`), or when its completion state is toggled (`TodoToggledIsCompletedState`).

```shell
event TodoCreated(
    uint id,
    address owner,
    string content,
    bool isCompleted
);

event TodoUpdated(
    uint id,
    string content,
    bool isCompleted
);

event TodoToggledIsCompletedState(
    uint id,
    bool isCompleted
);
```

The contract also has a modifier `onlyOwner` that restricts certain functions to be called only by the contract owner.

```shell
modifier onlyOwner {
    require(msg.sender == owner, "You aren't the owner");
    _;
}
```

"updateName": Allows the owner to update the name of the todo list.
```shell
function updateName(
    string memory _name
) public onlyOwner {
    name = _name;
}
```

"createTodo": Allows the owner to create a new todo. It increments `_todosCounter` and uses it as the id of the new todo.

```shell
function createTodo(
    string memory _content
) public onlyOwner {
    uint _id = _todosCounter;

    Todo storage newTodo = allTodos[_id];
    newTodo.id = _id;
    newTodo.owner = msg.sender;
    newTodo.content = _content;
    newTodo.isCompleted = false;

    emit TodoCreated(newTodo.id, newTodo.owner, newTodo.content, newTodo.isCompleted);

    _todosCounter++;
}
```

"updateTodo": Allows the owner to update the content and completion state of a todo.
```shell
function updateTodo(
    uint _id, 
    string memory _content, 
    bool _isCompleted
) public onlyOwner {
    require(_id <= _todosCounter, "Todo doesn't exist");

    Todo storage todo = allTodos[_id];

    todo.content = _content;
    todo.isCompleted = _isCompleted;

    emit TodoUpdated(todo.id, todo.content, todo.isCompleted);
}
```

"toggleCompletedById": Allows the owner of a specific todo to toggle its completion state.
```shell
function toggleCompletedById(uint _id) public {
    require(msg.sender == allTodos[_id].owner, "You are not the owner of this todo");

    Todo storage todo = allTodos[_id];
    todo.isCompleted = todo.isCompleted ? false : true;

    emit TodoToggledIsCompletedState(todo.id, todo.isCompleted);
}
```

"getAllTodos": Returns all todos in an array. It iterates over the `allTodos` mapping and copies each todo into a new array.
```shell
function getAllTodos() public view returns (Todo[] memory) {
    uint totalTodosCount = _todosCounter;

    Todo[] memory todos = new Todo[](totalTodosCount);
    for (uint i = 0; i < totalTodosCount; i++) {
        Todo memory currentTodo = allTodos[i];
        todos[i] = currentTodo;
    }

    return todos;
}
```

"getTodoById": Returns a specific todo by its id.
```shell
function getTodoById(
    uint _id
) public view returns (Todo memory) {
    require(_id <= _todosCounter, "Todo doesn't exist");

    Todo memory todo = allTodos[_id];

    return todo;
}
```

"queryCompletedTodosByAddress` and "queryIncompleteTodosByAddress": These functions return all completed or incomplete todos of a specific owner. They first count the number of completed or incomplete todos of the owner, then create a new array of that size, and finally copy the appropriate todos into the new array.
```shell
function queryCompletedTodosByAddress(
    address _owner
) public view returns (Todo[] memory) {
    uint completedTodosCount = 0;
    uint totalTodosCount = _todosCounter;

    for (uint i = 0; i < totalTodosCount; i++) {
        if (allTodos[i].isCompleted == true && allTodos[i].owner == _owner) {
            completedTodosCount++;
        }
    }

    Todo[] memory todos = new Todo[](completedTodosCount);
    uint currentIndex = 0;

    for (uint i = 0; i < totalTodosCount; i++) {
        if (allTodos[i].isCompleted == true && allTodos[i].owner == _owner) {
            todos[currentIndex] = allTodos[i];
            currentIndex++;
        }
    }

    return todos;
}

function queryIncompleteTodosByAddress(
    address _owner
) public view returns (Todo[] memory) {
    uint incompleteTodosCount = 0;
    uint totalTodosCount = _todosCounter;

    for (uint i = 0; i < totalTodosCount; i++) {
        if (allTodos[i].isCompleted == false && allTodos[i].owner == _owner) {
            incompleteTodosCount++;
        }
    }

    Todo[] memory todos = new Todo[](incompleteTodosCount);
    uint currentIndex = 0;

    for (uint i = 0; i < totalTodosCount; i++) {
        if (allTodos[i].isCompleted == false && allTodos[i].owner == _owner) {
            todos[currentIndex] = allTodos[i];
            currentIndex++;
        }
    }

    return todos;
}
```