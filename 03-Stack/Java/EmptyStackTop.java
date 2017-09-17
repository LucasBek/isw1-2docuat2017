package stack;

public class EmptyStackTop extends StackTop {

	@Override
	public boolean isEmpty() {
		return Boolean.TRUE;
	}

	@Override
	public Integer size() {
		return 0;
	}

	@Override
	public Object content() throws Exception {
		throw new Exception(Stack.STACK_EMPTY_DESCRIPTION);
	}

	@Override
	public StackTop previous() throws Exception {
		throw new Exception(Stack.STACK_EMPTY_DESCRIPTION);
	}
}
